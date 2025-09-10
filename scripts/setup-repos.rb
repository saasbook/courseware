#!/usr/bin/env ruby
require 'json'
require 'date'

REPOS = [
  'cs169/flextensions',
  'cs169/lamorinda-spirit-van',
  'cs169/berkeley-reentry-student-program'
]

MILESTONES = [
  { title: 'Iteration 1', due_on: '2024-02-21' },
  { title: 'Iteration 2', due_on: '2024-03-07' },
  { title: 'Iteration 3', due_on: '2024-03-21' },
  { title: 'Iteration 4', due_on: '2024-04-11' },
  { title: 'Iteration 5', due_on: '2024-04-25' },
  { title: 'Iteration 6', due_on: '2024-05-09' }
]

LABELS = [
  { name: '⚠️ migration required', color: 'FFC31B' },
  { name: '💡research needed', color: '004AAE' },
  { name: '🏗️ infrastructure', color: '8236C7' },
  { name: '💎 testing', color: '018943' },
  { name: '👀 accessibility', color: 'E7115E' }
]

def setup_repository(repo)
  puts "Setting up #{repo}..."

  # Create milestones
  MILESTONES.each do |milestone|
    due_date = DateTime.parse(milestone[:due_on]).iso8601
    cmd = %Q(gh api repos/#{repo}/milestones -X POST -f title="#{milestone[:title]}" -f due_on="#{due_date}")
    system(cmd)
    puts "Created milestone: #{milestone[:title]}"
  rescue
    puts "Milestone '#{milestone[:title]}' already exists or failed"
  end

  # Create labels
  LABELS.each do |label|
    cmd = %Q(gh api repos/#{repo}/labels -X POST -f name="#{label[:name]}" -f color="#{label[:color]}")
    system(cmd)
    puts "Created label: #{label[:name]}"
  rescue
    puts "Label '#{label[:name]}' already exists or failed"
  end

  puts "Completed setup for #{repo}\n\n"
end

# Main execution
REPOS.each do |repo|
  setup_repository(repo)
end
