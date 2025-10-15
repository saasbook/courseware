#!/usr/bin/env ruby

require 'json'
require 'csv'
require 'optparse'
require 'set'

ORG = 'cs169'
TEMPLATE_REPO = 'saasbook/hw-rails-intro'
NUM_TEAMS = 31
CHIPS_NUM = '5.3'

# Parse command line arguments
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: create_team_repos.rb [options]"

  opts.on("--csv FILE", "CSV file with user/team data") do |file|
    options[:csv] = file
  end

  opts.on("--individual", "Create individual repos instead of team repos") do
    options[:individual] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

def create_repo_from_template(org, repo_name, template_repo)
  puts "Creating repository #{org}/#{repo_name} from template #{template_repo}..."

  result = `gh repo create #{org}/#{repo_name} \
    --template #{template_repo} \
    --private \
    --clone=false 2>&1`

  if $?.success?
    puts "✓ Created repository #{repo_name}"
    true
  else
    # Check for rate limit error
    if result.include?('rate limit') || result.include?('too quickly')
      puts "✗ Rate limit hit for #{repo_name}"
      # Try to get rate limit headers
      rate_info = `gh api rate_limit 2>&1`
      puts "Rate limit info: #{rate_info}" if $?.success?
    end
    puts "✗ Failed to create #{repo_name}: #{result.strip}"
    false
  end
end

def add_repo_to_team(org, team_slug, repo_name, permission = 'maintain')
  puts "Adding #{repo_name} to team #{team_slug} with #{permission} permissions..."

  result = `gh api orgs/#{org}/teams/#{team_slug}/repos/#{org}/#{repo_name} \
    --method PUT \
    --field permission=#{permission} 2>&1`

  if $?.success?
    puts "✓ Added #{repo_name} to team #{team_slug}"
    true
  else
    puts "✗ Failed to add #{repo_name} to team #{team_slug}: #{result.strip}"
    false
  end
end

def add_user_to_repo(org, repo_name, username, permission = 'maintain')
  puts "Adding #{username} to #{org}/#{repo_name} with #{permission} permissions..."

  result = `gh api repos/#{org}/#{repo_name}/collaborators/#{username} \
    --method PUT \
    --field permission=#{permission} 2>&1`

  if $?.success?
    puts "✓ Added #{username} to #{repo_name}"
    true
  else
    puts "✗ Failed to add #{username} to #{repo_name}: #{result.strip}"
    false
  end
end

def repo_exists?(org, repo_name)
  result = `gh repo view #{org}/#{repo_name} 2>/dev/null`
  $?.success?
end

def get_all_repos(org)
  puts "Fetching all repositories from #{org}..."
  result = `gh repo list #{org} --limit 1000 --json name --jq '.[].name'`

  if $?.success?
    repos = result.strip.split("\n").to_set
    puts "Found #{repos.size} existing repositories"
    repos
  else
    puts "⚠ Failed to fetch repositories, will check individually"
    Set.new
  end
end

def get_user_identifier(row)
  # Try multiple possible column names for GitHub username
  github_username = row['GitHub Username']&.strip || row['github']&.strip
  email = row['Email']&.strip || row['email']&.strip

  if github_username && !github_username.empty?
    return github_username
  elsif email && !email.empty?
    return email
  else
    return nil
  end
end

def sanitize_identifier(identifier)
  # If it looks like an email, only sanitize the part before @
  if identifier.include?('@')
    local_part = identifier.split('@').first
    # Keep alphanumeric, dots, underscores, hyphens
    local_part.gsub(/[^a-zA-Z0-9._-]/, '-')
  else
    # For usernames, keep alphanumeric, underscores, hyphens
    identifier.gsub(/[^a-zA-Z0-9_-]/, '-')
  end
end

if options[:individual] && options[:csv]
  # Individual mode with CSV
  puts "Creating individual repositories from CSV..."

  # Get all existing repos once
  existing_repos = get_all_repos(ORG)

  CSV.foreach(options[:csv], headers: true) do |row|
    identifier = get_user_identifier(row)

    if identifier.nil?
      puts "⚠ Skipping row - no GitHub username or email found"
      next
    end

    # Use identifier as part of repo name (sanitize it)
    safe_identifier = sanitize_identifier(identifier)
    repo_name = "fa25-#{safe_identifier}-chips-#{CHIPS_NUM}"

    puts "\n--- Processing #{identifier} ---"

    # Check if repo already exists
    if existing_repos.include?(repo_name)
      puts "Repository #{repo_name} already exists, skipping creation"
    else
      unless create_repo_from_template(ORG, repo_name, TEMPLATE_REPO)
        puts "Skipping user assignment for #{repo_name} due to creation failure"
        next
      end
      sleep 2

      # Add to our set of existing repos
      existing_repos.add(repo_name)
    end

    # Add user to repository
    add_user_to_repo(ORG, repo_name, identifier, 'maintain')
    sleep 0.5
  end

elsif options[:csv]
  # Team mode with CSV
  puts "Creating team repositories from CSV..."

  # Get all existing repos once
  existing_repos = get_all_repos(ORG)

  CSV.foreach(options[:csv], headers: true) do |row|
    team_num = row['Team']&.strip&.to_i

    if team_num.nil? || team_num <= 0
      puts "⚠ Skipping row - invalid team number"
      next
    end

    repo_name = "fa25-team-#{team_num}-chips-#{CHIPS_NUM}"
    team_slug = "fa25-team-#{team_num}"

    puts "\n--- Processing Team #{team_num} ---"

    if existing_repos.include?(repo_name)
      puts "Repository #{repo_name} already exists, skipping creation"
    else
      unless create_repo_from_template(ORG, repo_name, TEMPLATE_REPO)
        puts "Skipping team assignment for #{repo_name} due to creation failure"
        next
      end
      sleep 2

      # Add to our set of existing repos
      existing_repos.add(repo_name)
    end

    add_repo_to_team(ORG, team_slug, repo_name, 'maintain')
    sleep 0.5
  end

else
  # Default: create team repos 1-NUM_TEAMS
  puts "Creating team repositories for teams 1-#{NUM_TEAMS}..."

  # Get all existing repos once
  existing_repos = get_all_repos(ORG)

  (1..NUM_TEAMS).each do |team_num|
    repo_name = "fa25-team-#{team_num}-chips-#{CHIPS_NUM}"
    team_slug = "fa25-team-#{team_num}"

    puts "\n--- Processing Team #{team_num} ---"

    if existing_repos.include?(repo_name)
      puts "Repository #{repo_name} already exists, skipping creation"
    else
      unless create_repo_from_template(ORG, repo_name, TEMPLATE_REPO)
        puts "Skipping team assignment for #{repo_name} due to creation failure"
        next
      end
      sleep 2

      # Add to our set of existing repos
      existing_repos.add(repo_name)
    end

    add_repo_to_team(ORG, team_slug, repo_name, 'maintain')
    sleep 0.5
  end
end

puts "\n✅ Repository creation complete!"
