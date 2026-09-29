#!/usr/bin/env ruby
# frozen_string_literal: true

# Invite students to the org BY EMAIL, create per-team child teams under a
# parent team, and create one repo per team from a template.
#
# Safe to re-run: existing teams/repos/pending invitations are skipped.
# DRY RUN by default. Pass --apply to make changes.
#
# Input: TSV or CSV with two columns, team name and email (no header needed):
#   team-1<TAB>student@berkeley.edu
#
# Requires: gh (authenticated as an org owner), Ruby stdlib only.
#
# Why not invite-users.rb? It calls PUT /orgs/{org}/teams/{slug}/memberships/{user},
# which only accepts GitHub usernames. Email invites must use
# POST /orgs/{org}/invitations with team_ids; users join the team on acceptance.
# https://docs.github.com/en/rest/orgs/members#create-an-organization-invitation

require 'json'
require 'open3'
require 'optparse'
require 'set'

options = {
  org: 'cs169',
  parent_team: 'cs169a-fa26',
  semester: 'fa26',
  assignment: 'chips-4.8',
  template: 'saasbook/hw-rails-intro',
  repo_permission: 'maintain',
  staff_team: nil,
  apply: false,
  steps: %w[teams invite repos]
}

OptionParser.new do |opts|
  opts.banner = 'Usage: setup-semester-teams.rb [options] ROSTER_FILE'
  opts.on('--org ORG', "GitHub org (default #{options[:org]})") { |v| options[:org] = v }
  opts.on('--parent-team SLUG', "Parent team slug (default #{options[:parent_team]})") { |v| options[:parent_team] = v }
  opts.on('--semester PREFIX', "Prefix for team/repo names (default #{options[:semester]})") { |v| options[:semester] = v }
  opts.on('--assignment NAME', "Repo suffix (default #{options[:assignment]})") { |v| options[:assignment] = v }
  opts.on('--template OWNER/REPO', "Template repo (default #{options[:template]})") { |v| options[:template] = v }
  opts.on('--repo-permission PERM', "Team permission on its repo: pull|triage|push|maintain|admin (default #{options[:repo_permission]})") { |v| options[:repo_permission] = v }
  opts.on('--staff-team SLUG', 'Optional staff team to grant admin on every repo') { |v| options[:staff_team] = v }
  opts.on('--only STEPS', 'Comma list of steps: teams,invite,repos (default all)') { |v| options[:steps] = v.split(',') }
  opts.on('--apply', 'Actually make changes (default is dry run)') { options[:apply] = true }
end.parse!

roster_path = ARGV.first or abort('ROSTER_FILE required')
ORG = options[:org]
APPLY = options[:apply]

def gh(*args, allow_fail: false)
  out, err, status = Open3.capture3('gh', *args)
  return [status.success?, out, err] if allow_fail
  abort("gh #{args.join(' ')} failed:\n#{err}") unless status.success?
  out
end

def gh_json(*args)
  JSON.parse(gh('api', '--paginate', '--slurp', *args)).flatten
end

def act(description)
  if APPLY
    yield
  else
    puts "  [dry run] #{description}"
    nil
  end
end

# team-N -> fa26-team-N
def team_slug(opts, raw_team)
  "#{opts[:semester]}-#{raw_team}"
end
def repo_name(opts, raw_team)
  "#{opts[:semester]}-#{raw_team}-#{opts[:assignment]}"
end

# ---- Parse roster --------------------------------------------------------
roster = Hash.new { |h, k| h[k] = [] }
File.readlines(roster_path, chomp: true).each_with_index do |line, index|
  next if line.strip.empty?
  team, email = line.split(/[\t,]/).map(&:strip)
  next if index.zero? && email !~ /@/ # header row
  abort("Bad line #{index + 1}: #{line.inspect}") unless team && email&.include?('@')
  roster[team] << email.downcase
end
teams_sorted = roster.keys.sort_by { |t| t[/\d+/].to_i }
duplicates = roster.values.flatten.tally.select { |_, count| count > 1 }.keys
abort("Duplicate emails: #{duplicates.join(', ')}") unless duplicates.empty?

puts "#{APPLY ? 'APPLY' : 'DRY RUN'}: #{roster.values.sum(&:size)} students in #{roster.size} teams"
puts "Org=#{ORG} parent=#{options[:parent_team]} template=#{options[:template]}\n\n"

parent = JSON.parse(gh('api', "orgs/#{ORG}/teams/#{options[:parent_team]}"))
existing_teams = gh_json("orgs/#{ORG}/teams").to_h { |t| [t['slug'], t] }

# ---- Step 1: child teams -------------------------------------------------
if options[:steps].include?('teams')
  puts '== Teams'
  teams_sorted.each do |team|
    slug = team_slug(options, team)
    if existing_teams[slug]
      puts "  exists: #{slug}"
      next
    end
    created = act("create team #{slug} under #{parent['slug']}") do
      JSON.parse(gh('api', "orgs/#{ORG}/teams", '-X', 'POST',
                    '-f', "name=#{slug}", '-f', 'privacy=closed',
                    '-F', "parent_team_id=#{parent['id']}"))
    end
    if created
      existing_teams[created['slug']] = created
      puts "  created: #{created['slug']}"
    end
  end
end

# ---- Step 2: email invitations -------------------------------------------
if options[:steps].include?('invite')
  puts "\n== Invitations"
  pending = gh_json("orgs/#{ORG}/invitations").map { |i| i['email']&.downcase }.compact.to_set
  failures = []
  teams_sorted.each do |team|
    team_obj = existing_teams[team_slug(options, team)]
    roster[team].each do |email|
      if pending.include?(email)
        puts "  pending: #{email}"
        next
      end
      if team_obj.nil?
        puts "  [dry run] invite #{email} -> #{team_slug(options, team)} (team not created yet)"
        next
      end
      act("invite #{email} -> #{team_obj['slug']}") do
        ok, _out, err = gh('api', "orgs/#{ORG}/invitations", '-X', 'POST',
                           '-f', "email=#{email}", '-f', 'role=direct_member',
                           '-F', "team_ids[]=#{team_obj['id']}", allow_fail: true)
        if ok
          puts "  invited: #{email} -> #{team_obj['slug']}"
        else
          failures << [email, team_obj['slug'], err.strip.lines.last]
          puts "  FAILED: #{email}: #{err.strip.lines.last}"
        end
        sleep 1
      end
    end
  end
  unless failures.empty?
    puts "\n#{failures.size} invite(s) failed (often: email is already on an org member's account)."
    puts 'Add these by GitHub username once you know it:'
    failures.each { |email, slug, _| puts "  #{slug}\t#{email}" }
  end
end

# ---- Step 3: repos from template -----------------------------------------
if options[:steps].include?('repos')
  puts "\n== Repos"
  existing_repos = gh('repo', 'list', ORG, '--limit', '5000', '--json', 'name', '--jq', '.[].name').split("\n").to_set
  staff = options[:staff_team]
  teams_sorted.each do |team|
    name = repo_name(options, team)
    slug = team_slug(options, team)
    if existing_repos.include?(name)
      puts "  exists: #{name}"
    else
      act("create #{ORG}/#{name} from #{options[:template]} (private)") do
        gh('repo', 'create', "#{ORG}/#{name}", '--template', options[:template], '--private', '--clone=false')
        puts "  created: #{name}"
        sleep 2
      end
    end
    act("grant #{slug} #{options[:repo_permission]} on #{name}") do
      gh('api', "orgs/#{ORG}/teams/#{slug}/repos/#{ORG}/#{name}", '-X', 'PUT', '-f', "permission=#{options[:repo_permission]}")
    end
    next unless staff
    act("grant #{staff} admin on #{name}") do
      gh('api', "orgs/#{ORG}/teams/#{staff}/repos/#{ORG}/#{name}", '-X', 'PUT', '-f', 'permission=admin')
    end
  end
end

puts "\nDone.#{APPLY ? '' : ' Re-run with --apply to make these changes.'}"
