#!/usr/bin/env ruby

require 'json'
require 'optparse'

ORG = 'cs169'

pattern = ARGV[0]
if pattern.nil? || pattern.empty?
  STDERR.puts "Error: Please provide a repo name pattern to match"
  STDERR.puts "Usage: delete_repos.rb [--dry-run] <pattern>"
  exit 1
end

# Parse command line arguments
options = { dry_run: false }
OptionParser.new do |opts|
  opts.banner = "Usage: delete_repos.rb [options] <pattern>"

  opts.on("--dry-run", "Show what would be deleted without actually deleting") do
    options[:dry_run] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

def get_org_repos(org)
  puts "Fetching repositories from #{org}..."

  result = `gh repo list #{org} --limit 1000 --json name --jq '.[].name'`

  if $?.success?
    repos = result.strip.split("\n")
    puts "Found #{repos.length} total repositories"
    repos
  else
    puts "✗ Failed to fetch repositories"
    []
  end
end

def delete_repo(org, repo_name, dry_run)
  if dry_run
    puts "🔍 [DRY RUN] Would delete: #{org}/#{repo_name}"
  else
    puts "Deleting #{org}/#{repo_name}..."

    result = `gh repo delete #{org}/#{repo_name} --yes 2>&1`

    if $?.success?
      puts "✓ Deleted #{repo_name}"
    else
      puts "✗ Failed to delete #{repo_name}: #{result.strip}"
    end
  end
end

# Get all repos from org
all_repos = get_org_repos(ORG)

# Filter repos matching pattern: fa25-XXX-chips-4.8 but NOT fa25-team-X-chips-4.8
repos_to_delete = all_repos.select do |repo|
  repo.match?(pattern)
end

puts "\nRepositories matching deletion criteria:"
if repos_to_delete.empty?
  puts "None found"
  exit
end

repos_to_delete.each { |repo| puts "  - #{repo}" }
puts "\nTotal to delete: #{repos_to_delete.length}"

if options[:dry_run]
  puts "\n🔍 DRY RUN MODE - No repositories will be deleted\n\n"
else
  puts "\n⚠️ WARNING: This will permanently delete #{repos_to_delete.length} repositories!"
  print "Type 'DELETE' to confirm: "
  confirmation = $stdin.gets.chomp

  unless confirmation == 'DELETE'
    puts "Aborted"
    exit
  end

  puts "\nProceeding with deletion...\n\n"
end

# Delete repos
repos_to_delete.each do |repo|
  delete_repo(ORG, repo, options[:dry_run])
  sleep 0.5 unless options[:dry_run]
end

if options[:dry_run]
  puts "\n🔍 DRY RUN complete - no changes made"
else
  puts "\n✅ Deletion complete!"
end
