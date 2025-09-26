#!/usr/bin/env ruby

require 'json'

ORG = 'cs169'
TEMPLATE_REPO = 'saasbook/hw-rails-intro'

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

def repo_exists?(org, repo_name)
  result = `gh repo view #{org}/#{repo_name} 2>/dev/null`
  $?.success?
end

# Create repositories and assign to teams
(1..31).each do |team_num|
  repo_name = "fa25-team-#{team_num}-chips-4.8"
  team_slug = "fa25-team-#{team_num}"

  puts "\n--- Processing Team #{team_num} ---"

  # Check if repo already exists
  if repo_exists?(ORG, repo_name)
    puts "Repository #{repo_name} already exists, skipping creation"
  else
    # Create repository from template
    unless create_repo_from_template(ORG, repo_name, TEMPLATE_REPO)
      puts "Skipping team assignment for #{repo_name} due to creation failure"
      next
    end

    # Wait a moment for repo to be fully created
    sleep 1
  end

  # Add repository to team
  add_repo_to_team(ORG, team_slug, repo_name, 'maintain')

  # Rate limiting
  sleep 0.5
end

puts "\n✅ Repository creation and team assignment complete!"
