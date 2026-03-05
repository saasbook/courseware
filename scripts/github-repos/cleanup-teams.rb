#!/usr/bin/env ruby

require 'json'
require 'set'

ORG = 'cs169'

def run_gh(*args)
  output = `gh #{args.join(' ')} 2>&1`
  unless $?.success?
    $stderr.puts "Error running: gh #{args.join(' ')}"
    $stderr.puts output
    exit 1
  end
  output
end

def get_teams
  json = run_gh('api', "/orgs/#{ORG}/teams", '--paginate')
  JSON.parse(json)
end

def get_org_members
  json = run_gh('api', "/orgs/#{ORG}/members", '--paginate')
  JSON.parse(json).map { |u| u['login'] }
end

def get_team_members(team_slug)
  json = run_gh('api', "/orgs/#{ORG}/teams/#{team_slug}/members", '--paginate')
  JSON.parse(json).map { |u| u['login'] }
end

def get_all_team_members(teams)
  members = Set.new
  teams.each do |team|
    members.merge(get_team_members(team['slug']))
  end
  members
end

def get_all_team_members_except(teams, exclude_slugs)
  members = Set.new
  teams.each do |team|
    next if exclude_slugs.include?(team['slug'])
    members.merge(get_team_members(team['slug']))
  end
  members
end

def remove_user_from_org(username, dry_run: true)
  if dry_run
    puts "  [DRY RUN] Would remove: #{username}"
  else
    run_gh('api', '-X', 'DELETE', "/orgs/#{ORG}/members/#{username}")
    puts "  Removed: #{username}"
  end
end

# Main script
teams = get_teams
all_org_members = Set.new(get_org_members)

# Show option 0 for members not in any team
puts "Available options:"
puts "0. Members not in any team"

# Show parent teams
parent_teams = teams.select { |t| t['parent'].nil? }
parent_teams.each_with_index do |team, idx|
  subteam_count = teams.count { |t| t['parent']&.dig('slug') == team['slug'] }
  subteam_info = subteam_count > 0 ? " (#{subteam_count} subteams)" : ""
  puts "#{idx + 1}. #{team['name']} (slug: #{team['slug']})#{subteam_info}"
end

print "\nEnter selection (0 for no-team members, or parent team slug): "
selection = gets.chomp

if selection == '0'
  # Handle members not in any team
  all_team_members = get_all_team_members(teams)
  to_remove = all_org_members - all_team_members

  puts "\nMembers not in any team (#{to_remove.size}):"
  to_remove.each { |u| puts "  - #{u}" }
else
  # Handle parent team + subteams
  target_team = parent_teams.find { |t| t['slug'] == selection }
  unless target_team
    $stderr.puts "Parent team not found"
    exit 1
  end

  # Find all subteams
  subteams = teams.select { |t| t['parent']&.dig('slug') == selection }

  puts "\nTarget parent team: #{target_team['name']}"
  if subteams.any?
    puts "Subteams:"
    subteams.each { |st| puts "  - #{st['name']}" }
  end

  # Collect slugs to exclude from "other teams"
  exclude_slugs = [selection] + subteams.map { |st| st['slug'] }

  # Collect all members from target team and subteams
  target_members = Set.new(get_team_members(selection))
  subteams.each do |subteam|
    target_members.merge(get_team_members(subteam['slug']))
  end

  # Get members from all other teams (excluding parent + subteams)
  other_team_members = get_all_team_members_except(teams, exclude_slugs)

  # Calculate who to remove
  to_remove = target_members - other_team_members

  puts "\nMembers to remove (#{to_remove.size}):"
  to_remove.each { |u| puts "  - #{u}" }

  puts "\nProtected (in other teams): #{(target_members & other_team_members).size}"
end

puts "\n⚠️  Admin protection disabled - verify removals manually"

print "\nProceed with removal? [dry-run/yes/no]: "
response = gets.chomp.downcase

case response
when 'yes'
  to_remove.each { |u| remove_user_from_org(u, dry_run: false) }
  puts "\nDone!"
when 'dry-run', ''
  to_remove.each { |u| remove_user_from_org(u, dry_run: true) }
  puts "\nDry run complete. Run again and type 'yes' to execute."
else
  puts "Aborted."
end
