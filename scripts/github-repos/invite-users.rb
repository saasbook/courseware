#!/usr/bin/env ruby

require 'csv'
require 'json'
require 'set'

ORG = 'cs169'
PARENT_TEAM = 'fa25-students'
CSV_FILE = 'teams.csv'

def get_team_id(org, team_slug)
  result = `gh api orgs/#{org}/teams/#{team_slug} --jq '.id' 2>/dev/null`
  return result.strip.to_i if $?.success?
  nil
end

def create_subteam(org, parent_team_slug, subteam_name)
  parent_id = get_team_id(org, parent_team_slug)
  return false unless parent_id

  puts "Creating subteam #{subteam_name}..."

  result = `gh api orgs/#{org}/teams \
    --method POST \
    --field name='#{subteam_name}' \
    --field privacy=closed \
    --field parent_team_id=#{parent_id} 2>&1`

  if $?.success?
    puts "✓ Created subteam #{subteam_name}"
    true
  else
    puts "✗ Failed to create #{subteam_name}: #{result.strip}"
    false
  end
end

def invite_user_to_team(identifier, org, team_slug)
  puts "Inviting #{identifier} to #{org}/#{team_slug}..."

  result = `gh api orgs/#{org}/teams/#{team_slug}/memberships/#{identifier} \
    --method PUT \
    --field role=member 2>&1`

  if $?.success?
    puts "✓ Successfully invited #{identifier}"
  else
    puts "✗ Failed to invite #{identifier}: #{result.strip}"
  end
end

def get_user_identifier(row)
  # Prefer GitHub Username if available, otherwise use Email
  github_username = row['GitHub Username']&.strip
  email = row['Email']&.strip

  if github_username && !github_username.empty?
    return github_username
  elsif email && !email.empty?
    return email
  else
    return nil
  end
end

# Collect all team numbers from CSV
team_numbers = Set.new

CSV.foreach(CSV_FILE, headers: true) do |row|
  team_num = row['Team']&.strip&.to_i
  team_numbers.add(team_num) if team_num && team_num > 0
end

puts "Found teams: #{team_numbers.to_a.sort.join(', ')}"

# Create subteams 1-31 if they don't exist
(1..31).each do |num|
  subteam_slug = "fa25-team-#{num}"

  unless get_team_id(ORG, subteam_slug)
    create_subteam(ORG, PARENT_TEAM, subteam_slug)
    sleep 0.5
  else
    puts "Subteam #{subteam_slug} already exists"
  end
end

# Process invitations
CSV.foreach(CSV_FILE, headers: true) do |row|
  identifier = get_user_identifier(row)
  team_num = row['Team']&.strip&.to_i

  next if identifier.nil? || team_num.nil? || team_num <= 0

  subteam_slug = "fa25-team-#{team_num}"
  invite_user_to_team(identifier, ORG, subteam_slug)
  sleep 0.5
end
