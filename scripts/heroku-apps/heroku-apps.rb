#!/usr/bin/env ruby

require 'optparse'
require 'platform-api'
require 'yaml'
require 'csv'

def main()
  h = HerokuAppManager.new
  $opts = OptionParser.new do |opt|
    opt.banner = "Usage: #{__FILE__} [required options] [individual|team|delapps|delusers]
HEROKU_API_KEY must be set as an environment variable.
'individual' creates individual apps, 'team' creates team apps, 'delapps' deletes any apps with given prefix,
'delusers' deletes all users in CSV file from the team. All options are required except --extra-users.
It's safe to run multiple times, since existing apps/collaborators are left alone."
    opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at least "Team" and "Email" named columns') do |csv|
      h.read_teams_and_emails_from_csv(csv)
    end
    opt.on('-tTEAM', '--team=TEAM', 'Heroku team name that should own the apps') do |team|
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
  when 'delapps' then h.delete_apps
  when 'delusers' then h.delete_users
  else h.print_help_and_exit
  end
end

class HerokuAppManager
  attr_accessor :heroku_team, :app_prefix, :extra_users
  def initialize
    @heroku_team = nil
    @app_prefix = nil
    @extra_users = []
    @users = {} # email => sanitized leader part of email (eg: 'john.q+public@gmail.com' => 'johnqpublic')
    @teams = Hash.new {|hsh, key| hsh[key] = [] } # teamID => [email1, email2, ...]
    print_help_and_exit("HEROKU_API_KEY not defined in environment") unless (@key = ENV['HEROKU_API_KEY'])
    @heroku = PlatformAPI.connect_oauth(@key)
  end

  public

  def valid?
    @heroku_team && @app_prefix 
  end

  def read_teams_and_emails_from_csv(csv)
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    print_help_and_exit "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
      hash.has_key?('Team') && hash.has_key?('Email')
    data.each do |row|
      email = row['Email']
      print_help_and_exit("Duplicate email in #{csv}: #{email}") if @users.has_key?(email) # duplicate!
      @users[email] = user_part_of_email(email)
      @teams[row['Team']] << email
    end
  end

  def create_individual_apps
    message = %Q{In Heroku team '#{@heroku_team}', create individual apps for #{@users.keys.length} students starting with #{@app_prefix}}
    message << %Q{and also add users: #{@extra_users.join(', ')}} unless @extra_users.empty?
    confirm(message)
    begin
      @users.each_pair do |email,sanitized_username|
        appname = "#{@app_prefix}#{sanitized_username}"
        existing_apps.include?(appname) ?
          check_add_collaborators(appname,[email]) :
          create_app_and_add_collaborators(appname, [email])
      rescue Excon::Error => e
        "Error creating/adding collaborator on #{appname}: #{e.inspect}"
      end
    end
  end

  def create_team_apps
    confirm(%Q{In Heroku team '#{@heroku_team}', create #{@teams.keys.length} team apps starting with #{@app_prefix} and also add users: #{@extra_users.join(', ')}})
    @teams.each_pair do |team_id, emails|
      # if team id is numeric, treat as number and zero-pad to 2 digits, else leave as is
      team_id = sprintf("%02d", team_id) if team_id =~ /^[0-9]+$/
      appname = "#{@app_prefix}#{team_id}"
      existing_apps.include?(appname) ?
        check_add_collaborators(appname, emails) :
        create_app_and_add_collaborators(appname, emails)
    end
  end

  def delete_apps
    apps_to_delete = existing_apps.select { |app| app =~ /^#{@app_prefix}/ }
    STDERR.puts("No apps named #{@app_prefix}* exist in team '#{@heroku_team}'") || exit(0) if apps_to_delete.empty?
    confirm(%Q{In Heroku team '#{@heroku_team}', delete #{apps_to_delete.length} apps named #{@app_prefix}*})
    apps_to_delete.each do |app|
      puts "delete #{app}"
      @heroku.app.delete(app)
    end
  end

  def delete_users
    confirm(%Q{In Heroku team '#{@heroku_team}', delete any of the #{@users.keys.length} users who appear in CSV file})
    existing_team_users = @heroku.team_member.list(@heroku_team)
    @users.keys.each do |user|
      if existing_team_users.include?(user)
        puts "remove #{user}"
        @heroku.team_member.delete(@heroku_team, user)
      else
        puts "  skip #{user}"
      end
    end
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
    $1.gsub(/[^A-Za-z0-9]/, '-')
  end

  def confirm(description)
    puts description
    puts "\nType YES to continue, anything else to abort:"
    exit 1 unless (STDIN.gets.chomp == "YES")
  end

end                             # class HerokuAppManager

main()
