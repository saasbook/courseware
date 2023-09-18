#!/usr/bin/env ruby

require 'optparse'
require 'octokit'
require 'csv'

ENV['GITHUB_ORG_API_KEY'] = "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"

def main()
  puts "Script start."
  org = OrgManager.new
  $opts = OptionParser.new do |opt|
    opt.banner = "Usage: #{__FILE__} [required options] [invite|create_teams|indiv_repos|team_repos|
    remove_indiv_repos|remove_team_repos|remove_teams|remove_team_repo_access] [optional options]
    GITHUB_ORG_API_KEY for the org must be set as an environment variable."

    opt.separator ""
    opt.separator "Commands:"
    opt.separator "    invite: Create a team called STUDENTTEAM under the org..."
    opt.separator "            If STUDENTTEAM is already exist, the script will resent invitation to students."
    opt.separator "            (Temporary for special situations in Fa23)"
    opt.separator "            If PREFIX is provided, it will assume the csv file contains \"Team\" column, and create child teams under the STUDENTTEAM, and invites them to child teams.\n"
    opt.separator "    create_teams: Assuming students are in STUDENTTEAM, create child teams for students for CHIP 10.5 and add them to the child team. \n"
    opt.separator "    indiv_repos: Create CHIPS repo for each stedent in STUDENTTEAM. Repos' names are form like \"PREFIX-[username]-FILENAME\"\n"
    opt.separator "    team_repos: Create 10.5 repos for each child team. Repos' names are form like \"PREFIX-FILENAME-[Team number]\""
    opt.separator "                Make sure child teams are formed before running this command.\n"
    opt.separator "    remove_indiv_repos: Delete all repos whose names are formed like \"PREFIX-[username]-FILENAME\".\n"
    opt.separator "    remove_team_repos: Delete all repos whose names are formed like \"PREFIX-FILENAME-[Team number]\".\n"
    opt.separator "    remove_teams: Remove all students and child teams in STUDENTTEAM from the org. Remove STUDENTTEAM as well.\n"
    opt.separator "    remove_team_repo_access: Remove students access to CHIP 10.5 repos that are formed like \"PREFIX-FILENAME-[Team number]\".\n"
    opt.separator "Options:"

    opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at leaset "Email" named columns') do |csv|
      org.csv = csv
    end
    opt.on('-oORGNAME', '--orgname=ORGNAME', 'The name of the org') do |orgname|
      org.orgname = orgname
    end
    opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
      org.parentteam = studentteam
    end
    opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg fa23.') do |pfx|
      org.semester = pfx
    end
    opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
      org.base_filename = filename
    end
    opt.on('-tTEMPLATE', '--template=TEMPLATE', 'The repo name within the org to use as template') do |template|
      org.template = template
    end
    opt.on('-gGSITEAM', '--gsiteam=GSITEAM', 'The team name of all the staff team') do |gsiteam|
      org.gsiteam = gsiteam
    end
  end
  $opts.parse!
  command = ARGV.pop
  case command
  when 'invite' then org.invite
  when 'create_teams' then org.create_teams
  when 'indiv_repos' then org.indiv_repos
  when 'team_repos' then org.team_repos
  when 'remove_indiv_repos' then org.remove_indiv_repos
  when 'remove_team_repos' then org.remove_team_repos
  when 'remove_teams' then org.remove_teams
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
    @csv = nil
    @users = []
    @childteams = Hash.new { |hash, key| hash[key] = [] } # teamID => [email1, email2, ...]
    print_error("GITHUB_ORG_API_KEY not defined in environment") unless (@key = ENV['GITHUB_ORG_API_KEY'])
    @client = Octokit::Client.new(access_token: @key, scopes: ['user', 'user:email'])
  end

  private

  def read_users_from csv
    data = CSV.parse(IO.read(csv), headers: true)
    hash = data.first.to_h
    print_error "Need at least 'Email' (str) columns in #{csv}" unless
      hash.has_key?('Email')
    data.each do |row|
      @users << row['Email']
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

def to_slug(input)
  # Convert to lowercase
  slug = input.downcase

  # Replace characters other than 0-9, a-z, '.', '_', and '-'
  slug.gsub!(/[^0-9a-z.\-_]+/, '-')

  # Remove leading and trailing hyphens
  slug.gsub!(/^-+/, '')
  slug.gsub!(/-+$/, '')

  # Limit the string to 63 characters
  slug = slug[0, 63]

  return slug
end

  def invite_valid?
    if @orgname.nil? || @orgname.empty? || @csv.nil? || @parentteam.nil? || @parentteam.empty?
      return false
    end
    # process the csv file
    if @semester.nil?
      read_users_from @csv
    else
      read_teams_and_users_from @csv
    end
    true
  end

  def create_teams_valid?
    if @orgname.nil? || @orgname.empty? || @csv.nil? || @parentteam.nil? || @parentteam.empty? || @semester.nil?
      return false
    end
    read_teams_and_users_from @csv
    true
  end

  def repos_valid?
    !(@orgname.nil? || @parentteam.nil? || @semester.nil? || @template.nil? || !gsiteam_valid? || @base_filename.nil?)
  end

  def remove_valid?
    !(@orgname.nil? || @semester.nil? || @base_filename.nil?)
  end
  
  def remove_teams_valid?
    !(@orgname.nil? || @semester.nil? || @parentteam.nil?)
  end

  def gsiteam_valid?
    gsiteam_obj = nil
    if !@gsiteam.nil? && @gsiteam.length > 0 
      begin
        gsiteam_obj = @client.team_by_name(@orgname, to_slug(@gsiteam))
      rescue Octokit::NotFound
        print_error "Can't find the gsi team in the org."
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
    print_error "csv file, organization name, student team name are needed." unless invite_valid?
    if @semester.nil? 
      # Semester prefix is not provided

      # Looking for the STUDENTTEAM in the org, see if it is exist.
      begin
        parentteam_id = @client.team_by_name(@orgname, to_slug(@parentteam))['id']
      rescue Octokit::NotFound
        parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
      end

      @users.each do |student_email|
        if !@client.team_invitations(parentteam_id).any? {|invitations| invitations.email == student_email}
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
        parentteam_id = @client.team_by_name(@orgname, to_slug(@parentteam))['id']
      rescue Octokit::NotFound
        parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
      end

      # create child teams and invite students to the child teams
      # this is for Fa23, will delete in the future. 
      @childteams.each_key do |team|
        childteam_name = %Q{#{@semester}-#{team}}
        begin
          childteam = @client.team_by_name(@orgname, to_slug(childteam_name))
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

  def create_teams
    print_error "csv file, students team name, semester prefix, org name are needed." unless create_teams_valid?

    # Looking for the STUDENTTEAM in the org, see if it is exist.
    begin
      parentteam_id = @client.team_by_name(@orgname, to_slug(@parentteam))['id']
    rescue Octokit::NotFound
      print_error "Please make sure the invite command runs first, or students team is created."
    end

    email_to_username_map = {}

    @client.team_members(parentteam_id).each do |mem|
      team_mem = @client.user
      puts team_mem.login
    end

    @client.team_members(parentteam_id).each do |mem|
      email_to_username_map[mem.email] = mem.login
    end

    puts email_to_username_map

    failed_emails = []

    # create child teams and add students to their child teams
    @childteams.each_key do |team|
      childteam_name = %Q{#{@semester}-#{team}}
      begin
        childteam = @client.team_by_name(@orgname, to_slug(childteam_name))
      rescue Octokit::NotFound
        childteam = @client.create_team(@orgname, {name: %Q{#{@semester}-#{team}}, parent_team_id: parentteam_id})
      end
      childteam_id = childteam['id']
      @childteams[team].each do |email|
        if email_to_username_map.has_key? email
          @client.add_team_member(childteam_id, email_to_username_map[email])
        else
          # save the incorrect email
          failed_emails << email
        end
      end
    end

    # print the emails that is failed to add to child team
    if !failed_emails.empty?
      puts 'Failed to add these emails to child team:'
      puts failed_emails
    end
  end

  def indiv_repos
    print_error "orgname, student team name, base filename, template repo name, semester prefix, and gsi team name needed." unless repos_valid?
    
    # Looking for the STUDENTTEAM in the org, see if it is exist.
    begin
      parentteam_id = @client.team_by_name(@orgname, to_slug(@parentteam))['id']
    rescue Octokit::NotFound
      print_error "Please make sure students team is created."
    end

    gsiteam_id =  @client.team_by_name(@orgname, to_slug(@gsiteam)).id
    self_user_name = @client.user.login
    @client.team_members(parentteam_id).each do |mem|
      if self_user_name != mem.login
        new_repo_name = %Q{#{@semester}-#{mem.login}-#{@base_filename}}
        if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
          begin
            new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name, 
              {owner: @orgname, private: true})
          rescue Octokit::NotFound
            print_error "Template not found."
          end
          @client.add_collab(new_repo['full_name'], mem.login)
          @client.add_team_repository(gsiteam_id, new_repo['full_name'], {permission: 'admin'})
        end
      end
    end


    # can remove the below loop because in the future, there should not be child teams while we assigning the indiv repos. 
    @client.child_teams(parentteam_id).each.each do |mem|
      if !mem.login.nil? && self_user_name != mem.login
        new_repo_name = %Q{#{@semester}-#{mem.login}-#{@base_filename}}
        if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
          begin
            new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name, 
              {owner: @orgname, private: true})
          rescue Octokit::NotFound
            print_error "Template not found."
          end
          @client.add_collab(new_repo['full_name'], mem.login)
          @client.add_team_repository(gsiteam_id, new_repo['full_name'], {permission: 'admin'})
        end
      end
    end
  end

  def team_repos
    print_error "orgname, student team name, base filename, template repo name, semester prefix, and gsi team name needed." unless repos_valid?

    child_teams = @client.child_teams(@client.team_by_name(@orgname, to_slug(@parentteam)).id)
    gsiteam_id = @client.team_by_name(@orgname, to_slug(@gsiteam))['id']
    child_teams.each do |team|
      team_num = team.slug.match(/-(\d+)$/)[1]
      new_repo_name = %Q{#{@semester}-#{@base_filename}-#{team_num}}
      if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
        begin
          new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name, 
            {owner: @orgname, private: true})
        rescue Octokit::NotFound
          print_error "Template not found."
        end
        @client.add_team_repository(team.id, new_repo['full_name'], {permission: 'push'})
        @client.add_team_repository(gsiteam_id, new_repo['full_name'], {permission: 'admin'})
      end
    end

  end

  def remove_indiv_repos
    print_error "org name, base filename, semester prefix are needed." unless remove_valid?

    repos = @client.org_repos(@orgname, {:type => 'private'})
    repos.each do |repo|
      if repo.name =~ /^#{Regexp.escape(@semester)}-(.*)-#{Regexp.escape(@base_filename)}$/
        @client.delete_repository(repo.full_name)
      end
    end
  end

  def remove_team_repos
    print_error "org name, base filename, semester prefix are needed." unless remove_valid?

    repos = @client.org_repos(@orgname, {:type => 'private'})
    repos.each do |repo|
      if repo.name =~ /^#{Regexp.escape(@semester)}-#{Regexp.escape(@base_filename)}-\d+$/
        @client.delete_repository(repo.full_name)
      end
    end
  end

  def remove_teams
    print_error "org name, semester prefix, students team name are needed." unless remove_teams_valid?

    # Looking for the STUDENTTEAM in the org, see if it is exist.
    begin
      parentteam_id = @client.team_by_name(@orgname, to_slug(@parentteam))['id']
    rescue Octokit::NotFound
      print_error "Please make sure students team is created."
    end

    # Remove all members in the students team from org
    self_user_name = @client.user.login
    @client.team_members(parentteam_id).each do |mem|
      if !mem.login.nil? && mem.login != self_user_name
        @client.remove_organization_member(@orgname, mem.login)
      end 
    end

    @client.child_teams(parentteam_id).each do |childteam|
      @client.team_members(childteam.id).each do |mem|
        if !mem.login.nil? && mem.login != self_user_name
          @client.remove_organization_member(@orgname, mem.login)
        end
      end
    end

    # Remove students team, child team will be removed as well
    @client.delete_team parentteam_id
  end

  def remove_access
    print_error "org name, base filename, semester prefix are needed." unless remove_valid?

    repos = @client.org_repos(@orgname, {:type => 'private'})
    repos.each do |repo|
      match = repo.name.match(/^#{Regexp.escape(@semester)}-#{Regexp.escape(@base_filename)}-(\d+)$/)
      if match
        team_num = match[1]
        begin
          childteam_id = @client.team_by_name(@orgname, to_slug(%Q{#{@semester}-#{team_num}}))['id'] # eg slug fa23-1
        rescue Octokit::NotFound
          next
        end
        @client.remove_team_repository(childteam_id, repo)
      end
    end
  end
end

main