#!/usr/bin/env ruby
require 'json'

ORG = 'cs169'
REPO_PREFIX = 'fa25-chips-10.5'

repos_json = `gh api --paginate "/orgs/#{ORG}/repos" --jq '.[].name'`
repos = repos_json.split("\n").select { |repo| repo.start_with?(REPO_PREFIX) }

puts "Found #{repos.length} repos matching '#{REPO_PREFIX}*'\n\n"

# Dry Run:
# repos.each do |repo|
#   teams_json = `gh api "/repos/#{ORG}/#{repo}/teams"`
#   teams = JSON.parse(teams_json)

#   write_teams = teams.select { |t| t['permission'] == 'push' }
#   if write_teams.any?
#     puts "#{repo}:"
#     write_teams.each { |t| puts "  - #{t['name']}" }
#   end
# end

repos.each do |repo|
  puts "\nProcessing: #{repo}"

  # Get teams for this repo
  teams_json = `gh api "/repos/#{ORG}/#{repo}/teams"`
  teams = JSON.parse(teams_json)

  teams.each do |team|
    if team['permission'] == 'push' # 'push' = write access
      team_slug = team['slug']
      puts "  Updating #{team['name']} from write to admin..."

      # Update permission to admin
      system("gh api -X PUT \"/orgs/#{ORG}/teams/#{team_slug}/repos/#{ORG}/#{repo}\" -f permission=admin")
    end
  end
end

puts "\nDone!"
