#!/usr/bin/env ruby

require 'optparse'
require 'octokit'
require 'csv'

ENV['GITHUB_ORG_API_KEY'] = ""

def main()
  puts "Script start."
  org = OrgManager.new
  $opts = OptionParser.new do |opt|
    opt.banner = "Usage: #{__FILE__} [required options] [invite|create_teams|indiv_repos|team_repos|
    remove_indivi_repos|remove_team_repos|remove_teams|remove_team_repo_access] [optional options]
    GITHUB_ORG_API_KEY for the org must be set as an environment variable."

    opt.separator ""
    opt.separator "Commands:"
    opt.separator "    invite: Create a team called STUDENTTEAM under the org..."
    opt.separator "            If STUDENTTEAM is already exist, the script will resent invitation to students."
    opt.separator "            (Temporary for special situations in Fa23)"
    opt.separator "            If PREFIX is provided, it will assume the csv file contains \"Team\" column, and create child teams under the STUDENTTEAM, and invites them to child teams.\n"
    opt.separator "    create_teams: Create child teams for students for CHIP 10.5 \n"
    opt.separator "    indiv_repos: Create CHIPS repo for each stedent in STUDENTTEAM. Repos' names are form like \"PREFIX-[username]-FILENAME\"\n"
    opt.separator "    team_repos: Create 10.5 repos for each child team. Repos' names are form like \"PREFIX-FILENAME-[Team number]\""
    opt.separator "                Make sure child teams are formed before running this method.\n"
    opt.separator "    remove_indiv_repos: Delete all repos whose names are formed like \"PREFIX-[username]-FILENAME\".\n"
    opt.separator "    remove_team_repos: Delete all repos whose names are formed like \"PREFIX-FILENAME-[Team number]\".\n"
    opt.separator "    remove_teams: Remove all students and child teams in STUDENTTEAM from the org. Remove STUDENTTEAM as well.\n"
    opt.separator "    remove_team_repo_access: Remove students access to CHIP 10.5 repos that are formed like \"PREFIX-FILENAME-[Team number]\".\n"
    opt.separator "Required options:"

    case ARGV[0]
    when 'invite'
      opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at leaset "Email" named columns') do |csv|
        org.csv = csv
      end
      opt.on('-oORGNAME', '--orgname=ORGNAME', 'The name of the org') do |orgname|
        org.orgname = orgname
      end
      opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
      end
      opt.separator "Optional options:"
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
    when 'create_teams'
      opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at least "Team" and "Email" named columns') do |csv|
        org.read_teams_and_users_from csv
      end
      opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
      end
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
    when 'indiv_repos'
      opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
      end
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
      opt.on('-tTEMPLATE', '--template=TEMPLATE', 'The repo name within the org to use as template') do |template|
        org.template = template
      end
      opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
      end
      opt.on('-gGSITEAM', '--gsiteam=GSITEAM', 'The team name of all the staff team') do |gsiteam|
        org.gsiteam = gsiteam
      end
    when 'team_repos'      
      opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
      end
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
      opt.on('-tTEMPLATE', '--template=TEMPLATE', 'The repo name within the org to use as template') do |template|
        org.template = template
      end
      opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
      end
      opt.on('-gGSITEAM', '--gsiteam=GSITEAM', 'The team name of all the staff team') do |gsiteam|
        org.gsiteam = gsiteam
      end
    when 'remove_idiv_repos'
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
      opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
      end
    when 'remove_team_repos'
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
      opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
      end
    when 'remove_teams'
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
      opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
      end
    when 'remove_team_repo_access'
      opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
      end
      opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
        org.semester = pfx
      end
    end
  end
  $opts.parse!
  command = ARGV.pop
  # case command
  # when 'invite' then org.invite
  # when 'repos' then org.create_repos 
  # when 'remove' then org.remove
  # when 'remove_access' then org.remove_access
  # else org.print_error
  # end
  case command
  when 'invite' then org.invite
  when 'create_teams'
  when 'indiv_repos'
  when 'team_repos'  
  when 'remove_idiv_repos'
  when 'remove_team_repos'
  when 'remove_teams'
  when 'remove_team_repo_access'
  else org.print_error
  end
  puts "Run successfully."
  puts "Script ends."
end

class OrgManager
  attr_accessor :orgname, :base_filename, :semester, :template, :parentteam, :gsiteam, :csv, :users

  def initialize
    @orgname = nil
    @base_filename = nil
    @semester = nil
    @template = nil
    @has_childteams = false
    @users = []
    @childteams = Hash.new { |hash, key| hash[key] = [] } # teamID => [email1, email2, ...]
    print_error("GITHUB_ORG_API_KEY not defined in environment") unless (@key = ENV['GITHUB_ORG_API_KEY'])
    @client = Octokit::Client.new(access_token: @key)
  end

  private

  def read_users_from csv
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    print_error "Need at least 'Email' (str) columns in #{csv}" unless
      hash.has_key?('Email')
    data.each do |row|
      @users << username
    end
  end

  def read_teams_and_users_from csv
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    print_error "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
      hash.has_key?('Team') && hash.has_key?('Email')
    data.each do |row|
      username = row['Email']
      @childteams[row['Team']] << username
    end
  end

  def invite_valid?
    # process the csv file
    if @orgname.nil? || @orgname.empty? || @csv.nil? || @parentteam.nil? || @parentteam.empty?
      return false
    end
    if @semester.nil?
      read_users_from @csv
    else
      read_teams_and_users_from @csv
    end
    true
  end

  def gsiteam_valid?
    gsiteam_obj = nil
    if !@gsiteam.nil? && @gsiteam.length > 0 
      begin
        gsiteam_obj = @client.team_by_name(@orgname, @gsiteam)
      rescue Octokit::NotFound
      end
    end
    !gsiteam_obj.nil?
  end

  public

  def valid?
    @orgname && @base_filename && @semester && @childteams.length > 0 && @template && @parentteam && gsiteam_valid?
  end

  def print_error(msg=nil)
    STDERR.puts "Error: #{msg}" if msg
    STDERR.puts $opts
    exit 1
  end

  def invite
    print_error "csv file, organization name, student team name are needed." unless valid?
    if @semester.nil? 
      # Semester prefix is not provided

      # Looking for the STUDENTTEAM in the org, see if it is exist.
      begin
        parentteam_id = @client.team_by_name(@orgname, @parentteam)['id']
      rescue Octokit::NotFound
        parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
      end

      @users.each do |student_email|
        if !@client.team_invitations(parentteam_id).any? {|invitations| invitations.email == member}
          # invitation is not pending, send invitation
          begin
            @client.post(%Q{/orgs/#{@orgname}/invitations}, {org: @orgname, email: student_email , role: 'direct_member', team_ids: [parentteam_id]})
          rescue Octokit::UnprocessableEntity
            # send fail, member is already a part of org
            next
          end
        end
      end
    else
      # Semester prefix is provied
      
      # Looking for the STUDENTTEAM in the org, see if it is exist.
      begin
        parentteam_id = @client.team_by_name(@orgname, @parentteam)['id']
      rescue Octokit::NotFound
        parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
      end

      # create child teams and invite students to the child teams
      # this is for Fa23, will delete in the future. 
      @childteams.each_key do |team|
        childteam_name = %Q{#{@semester}-#{team}}
        begin
          childteam = @client.team_by_name(@orgname, childteam_name)
        rescue Octokit::NotFound
          childteam = @client.create_team(@orgname, {name: %Q{#{@semester}-#{team}}, parent_team_id: parentteam_id})
        end
        childteam_id = childteam['id']
        @childteams[team].each do |member|
          # Try no check invitations before create one.
          if !@client.team_invitations(childteam_id).any? {|invitations| invitations.email == member}
            # send invitation
            begin
              @client.post(%Q{/orgs/#{@orgname}/invitations}, {org: @orgname, email: member, role: 'direct_member', team_ids: [childteam_id]})
            rescue Octokit::UnprocessableEntity
              # member is already a part of org
              next
            end
          end
        end
      end

    end
  end

  def create_repos
    print_error "csv file, base filename, template repo name, semester prefix, students team name, and gsi team name needed." unless valid?
    @childteams.each_key do |team|
      begin
        team_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id']
      rescue Octokit::NotFound
        print_error "Students teams information mismatched."
      end
      gsiteam_id = @client.team_by_name(@orgname, @gsiteam)['id']
      new_repo_name = %Q{#{@semester}-#{@base_filename}-#{team}}
      if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
        begin
          new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name, 
            {owner: @orgname, private: true})
        rescue Octokit::NotFound
          print_error "Template not found."
        end
        @client.add_team_repository(team_id, new_repo['full_name'], {permission: 'push'})
        @client.add_team_repository(gsiteam_id, new_repo['full_name'], {permission: 'admin'})
      end
    end
  end

  def remove
    print_error "csv file, base filename, template repo name, semester prefix, students team name, and gsi team name needed." unless valid?
    # remove and delete all repos from the students team, delete all child teams
    # also cancel all pending invitaions
    @childteams.each_key do |team|
      repo_name = %Q{#{@orgname}/#{@semester}-#{@base_filename}-#{team}}
      @client.delete_repository(repo_name)
      begin
        childteam_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id'] # eg slug fa23-01
      rescue Octokit::NotFound
        next
      end

      # remove students from the student teams
      team_members = @client.team_members(childteam_id)
      team_members.each do |member|
        if @client.organization_membership(@orgname, :user => member['login'])['role'] == 'member'
          @client.remove_organization_member(@orgname, member['login'])
        end
      end

      @client.team_invitations(childteam_id).each do |invitation|
        # cancel all pending invitations
        @client.delete(%Q{/orgs/#{@orgname}/invitations/#{invitation[:id]}})
      end
      @client.delete_team childteam_id
    end
    # delete students team
    begin
      team_id = @client.team_by_name(@orgname, @parentteam)['id']
      @client.delete_team team_id
    rescue Octokit::NotFound
      # do nothing if no such team
    end
  end
  
  def remove_access
    @childteams.each_key do |team|
      repo_name = %Q{#{@orgname}/#{@semester}-#{@base_filename}-#{team}}
      begin
        childteam_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id'] # eg slug fa23-1
      rescue Octokit::NotFound
        next
      end
      @client.remove_team_repository(childteam_id, repo_name)
    end
  end
end

main