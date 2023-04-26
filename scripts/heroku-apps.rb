#!/usr/bin/env ruby

require 'byebug'
require 'optparse'
require 'platform-api'
require 'yaml'
require 'csv'

def main()
  h = HerokuAppManager.new
  $opts = OptionParser.new do |opt|
    opt.banner = "Usage: #{__FILE__} [required options] [individual|team|delete].\n'individual' creates individual apps, 'team' creates team apps, 'delete' cleans up (deletes) any apps with given prefix. All options are required except --extra-users."
    opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at least "Team" and "Email" named columns') do |csv|
      h.read_teams_and_emails_from_csv(csv)
    end
    opt.on('-tTEAM', '--heroku-team=TEAM', 'Heroku team name that should own the apps') do |team|
      h.heroku_team = team
    end
    opt.on('-pPREFIX', '--prefix=PREFIX', 'App name prefix, eg "fa23" gives apps "fa23-01", "fa23-02", etc.') do |pfx|
      h.app_prefix = pfx
    end
    opt.on('-xEMAILS' '--extra-users=EMAILS', 'Comma-separated list of emails that should also be collaborators on apps') do |extra_users|
      h.extra_users = extra_users.split(/,/)
    end
  end
  $opts.parse!
  h.print_help_and_exit unless h.valid?
  command = ARGV.pop
  case command
  when 'individual' then h.create_individual_apps
  when 'team' then h.create_team_apps
  when 'delete' then h.delete_apps
  else h.print_help_and_exit
  end
end

class HerokuAppManager
  attr_accessor :heroku_team, :app_prefix, :extra_users
  def initialize
    @heroku_team = nil
    @app_prefix = nil
    @extra_users = nil
    @users = {} # email => sanitized leader part of email (eg: 'john.q+public@gmail.com' => 'johnqpublic')
    @teams = Hash.new {|hsh, key| hsh[key] = [] } # teamID => [email1, email2, ...]
    print_help_and_exit("HEROKU_API_KEY not defined in environment") unless (@key = ENV['HEROKU_API_KEY'])
    @heroku = PlatformAPI.connect_oauth(@key)
  end

  public

  def valid?
    @heroku_team && @app_prefix && @extra_users
  end

  def read_teams_and_emails_from_csv(csv)
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    print_help_and_exit "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
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

  def create_individual_apps
    confirm(%Q{In Heroku team '#{@heroku_team}', create #{@users.keys.length} individual apps starting with #{@app_prefix} and also add users: #{@extra_users.join(', ')}})
    begin
      @users.each_pair do |email,sanitized_username|
        appname = "#{@app_prefix}#{sanitized_username}"
        existing_apps.include?(appname) ?
          check_add_collaborator(appname,email) :
          create_app_and_add_collaborators(appname, [email])
      rescue Excon::Error => e
        "Error creating/adding collaborator on #{appname}: #{e.inspect}"
      end
    end
  end

  def create_team_apps
    confirm(%Q{In Heroku team '#{@heroku_team}', create #{@teams.keys.length} team apps starting with #{@app_prefix} and also add users: #{@extra_users.join(', ')}})
  end

  def delete_apps
    count = existing_apps.select { |app| app =~ /^#{@app_prefix}/ }.count
    confirm(%Q{In Heroku team '#{@heroku_team}', delete #{count} apps named #{@app_prefix}*, and delete any of their collaborators who appear in CSV file})
    byebug
  end
  
  def print_help_and_exit(msg=nil)
    STDERR.puts "Error: #{msg}" if msg
    STDERR.puts $opts
    exit 1
  end

  def existing_apps
    @existing_apps ||= @heroku.team_app.list_by_team(@heroku_team).map { |app| app['name'] }
  end

  private

  def check_add_collaborators(appname, emails)
    puts "exists #{appname}"
    emails.each do |email|
      if @heroku.collaborator.list(appname).
           map { |c| c['user']['email'] }.
           include?(email)
        puts "  exists collaborator #{email}"
      else
        puts "  create collaborator #{email}"
        @heroku.collaborator.create(appname, { user: email, silent: true })
      end
    end
  end

  def create_app_and_add_collaborators(appname, emails)
    puts "create #{appname}"
    @heroku.team_app.create(name: appname, team: @heroku_team, locked: true)
    puts "  create collaborators #{emails.join(', ')}"
    emails.each do |email|
      @heroku.collaborator.create(appname, { user: email, silent: true })
    end
  end

  def user_part_of_email(email)
    puts "Email #{email} not valid" and exit 1 unless email =~ /^([^@]+)@([^@]+)$/
    $1.gsub(/[^A-Za-z0-9]/, '')
  end

  def confirm(description)
    puts description
    puts "\nType YES to continue, anything else to abort:"
    exit 1 unless (STDIN.gets.chomp == "YES")
  end

end                             # class HerokuAppManager

main()
