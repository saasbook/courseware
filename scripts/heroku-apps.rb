#!/usr/bin/env ruby

require 'byebug'

require 'platform-api'
require 'yaml'
require 'csv'

def main()
  print_help and exit 1 unless (yml = ARGV[0]  &&  csv = ARGV[1])
  y = (YAML.load_file yml)['heroku']
  $teams = Hash.new {|hsh, key| hsh[key] = [] }
  read_teams_and_emails_from_csv(csv) or exit 1
  byebug
  approve_summary_of_what_to_do(y) or exit 0
  #$h = PlatformAPI.connect_oauth(ENV['HEROKU_API_KEY'])
end


def delete_all_collaborators_except(exceptions_list)
  
end

def delete_apps_matching_regexp(regexp)
end
def add_user_to_app(email, appname)
  begin
    $h.collaborator.create(appname, { user: email, silent: true })
  rescue Excon::Error => e
    "Error adding #{email} to #{appname}: #{e.inspect}"
  end
end

def print_help
  STDERR.puts <<EOerr
Usage: #{__FILE__} somefile.yml somefile.csv
Example yml contents:
heroku:
  team: "esaas"
  apps:
    delete_regexp: "^sp23-"
    create_format: "fa23-%02d-actionmap"
  keep_users:
    - governify.auditor@gmail.com

CSV file must contain at least columns named "Team" and "Email".
Team should be an integer from 0 to n-1.
EOerr
  true
end

def approve_summary_of_what_to_do(y)
  puts %Q{In team '#{y["team"]}':}
  puts %Q{   delete apps matching /#{y["apps"]["delete_regexp"]}/} <<
       %Q{create #{y["apps"]["num_new"]} apps numbered } <<
       %Q{#{sprintf(y["apps"]["create_format"],0)}, #{sprintf(y["apps"]["create_format"],1)}, etc.}
  puts %Q{   deleting all non-member/non-admin collaborators EXCEPT: } <<
       %Q{#{y["keep_users"].join(',')}}

  puts "\nType YES to continue, anything else to abort:"
  (STDIN.gets.chomp == "YES")
end
  
def read_teams_and_emails_from_csv(csv)
  data = CSV.parse(IO.read(csv), headers: true)
  hash = data.first.to_h
  puts "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" and return nil unless
    hash.has_key?('Team') && hash.has_key?('Email')
  data.each do |row|
    $teams[row['Team']] << row['Email']
  end
  
end
  

main()
