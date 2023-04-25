#!/usr/bin/env ruby

require 'byebug'

require 'platform-api'
require 'yaml'
require 'csv'

def main()
  h = HerokuAppManager.new
  h.print_help_and_exit unless (yml = ARGV[0])  &&  (csv = ARGV[1])
  h.read_yaml(yml)
  h.read_teams_and_emails_from_csv(csv)
  h.approve_summary_of_what_to_do
end

class HerokuAppManager
  attr_reader :heroku_team, :app_prefix, :extra_users, :teams
  def initialize
    @heroku_team = 'esaas'
    @app_prefix = 'app-'
    @extra_users = []
    @users = {} # email => sanitized leader part of email (eg: 'john.q+public@gmail.com' => 'johnqpublic')
    @teams = Hash.new {|hsh, key| hsh[key] = [] } # teamID => [email1, email2, ...]
    print_help_and_exit("HEROKU_API_KEY not defined in environment") unless (@key = ENV['HEROKU_API_KEY'])
    h = PlatformAPI.connect_oauth(@key)
  end

  private
  def user_part_of_email(email)
    puts "Email #{email} not valid" and exit 1 unless email =~ /^([^@]+)@([^@]+)$/
    $1.gsub(/[^A-Za-z0-9]/, '')
  end

  public

  def read_yaml(filename)
    y = (YAML.load_file filename)
    HerokuAppManager.print_help_and_exit("heroku_team and app_prefix must be present in .yml") unless
      (@heroku_team = y.delete('heroku_team')) &&
      (@app_prefix = y.delete('app_prefix'))
    @extra_users = y.delete('extra_users') || []
    print_help_and_exit("Unknown key(s) in yaml: #{y.keys}") unless y.keys.empty?
  end

  def read_teams_and_emails_from_csv(csv)
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    HerokuAppManager.print_help_and_exit "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
      hash.has_key?('Team') && hash.has_key?('Email')
    data.each do |row|
      email = row['Email']
      if @users.has_key?(email) # duplicate!
        puts "Duplicate email: #{email}" and exit 1
      end
      @users[email] = user_part_of_email(email)
      @teams[row['Team']] << email
    end
  end

  def approve_summary_of_what_to_do
    puts %Q{In Heroku team '#{@heroku_team}':}
    puts %Q{   create team apps #{@app_prefix}00..#{@app_prefix}#{sprintf "%02d",@teams.keys.length-1}}
    puts %Q{   create #{@users.keys.length} individual apps starting with #{@app_prefix} and also add users: #{@extra_users.join(', ')}}
    puts "\nType YES to continue, anything else to abort:"
    (STDIN.gets.chomp == "YES")
  end
  

  def add_user_to_app(email, appname)
    begin
      $h.collaborator.create(appname, { user: email, silent: true })
    rescue Excon::Error => e
      "Error adding #{email} to #{appname}: #{e.inspect}"
    end
  end

  def print_help_and_exit(msg=nil)
    STDERR.puts "Error: #{msg}" if msg
    STDERR.puts <<EOerr
Usage: #{__FILE__} somefile.yml somefile.csv

Example yml contents:

  # required: team name in heroku account where apps should be created
  heroku_team: "esaas"
  # required: how to name the apps.  for individual apps, sanitized student email
  # will be appended; for team apps, team number padded to 2 digits will be appended
  app_prefix: "fa23-"
  # optional: users that must be added to every app, in addition to the student(s)
  extra_users:
    - governify.auditor@gmail.com
    - ball@berkeley.edu

CSV file must contain at least columns named "Team" and "Email".
Team should be an integer from 0 to n-1.
EOerr
    exit 1
  end
end

main()
