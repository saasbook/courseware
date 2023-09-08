#!/usr/bin/env ruby

require 'optparse'
require 'octokit'
require 'csv'

def main()
    puts "Script start."
    org = OrgManager.new
    $opts = OptionParser.new do |opt|
        opt.banner = "Usage: #{__FILE__} [required options] [invite|repos|remove]
    GITHUB_ORG_API_KEY for the org must be set as an environment variable.
    'invite' invites students provided in .csv file and creates teams, 
    'repos' creates team repos, 'remove' remove students, repos, teams from the org."
        opt.on('-cCSVFILE', '--csv=CSVFILE', 'CSV file containing at least "Team" and "Email" named columns') do |csv|
        org.read_teams_and_emails_from csv
        end
        opt.on('-oORGNAME', '--orgname=ORGNAME', 'The name of the org') do |orgname|
        org.orgname = orgname
        end
        opt.on('-fFILENAME', '--filename=FILENAME', 'The base filename for repos') do |filename|
        org.base_filename = filename
        end
        opt.on('-pPREFIX', '--prefix=PREFIX', 'Semester prefix, eg "fa23" create a repos prefix, "fa23-actionmap-04", etc') do |pfx|
        org.semester = pfx
        end
        opt.on('-tTEMPLATE', '--template=TEMPLATE', 'The repo name within the org to use as template eg repo_name') do |template|
        org.template = template
        end
        opt.on('-sSTUDENTTEAM', '--studentteam=STUDENTTEAM', 'The team name of all the students team') do |studentteam|
        org.parentteam = studentteam
        end
        opt.on('-gGSITEAM', '--gsiteam=GSITEAM', 'The team name of all the staff team') do |gsiteam|
        org.gsiteam = gsiteam
        end
    end
    $opts.parse!
    command = ARGV.pop
    case command
    when 'invite' then org.invite
    when 'repos' then org.create_repos 
    when 'remove' then org.remove
    when 'remove_access' then org.remove_access
    else org.print_error
    end
    puts "Run successfully."
    puts "Script ends."
end

class OrgManager
    attr_accessor :orgname, :base_filename, :semester, :template, :parentteam, :gsiteam

    def initialize
        @orgname = nil
        @base_filename = nil
        @semester = nil
        @template = nil
        @childteams = Hash.new { |hash, key| hash[key] = [] } # teamID => [email1, email2, ...]
        print_error("GITHUB_ORG_API_KEY not defined in environment") unless (@key = ENV['GITHUB_ORG_API_KEY'])
        @client = Octokit::Client.new(access_token: @key)
    end

    private

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

    def read_teams_and_emails_from csv
        data = CSV.parse(IO.read(csv), headers: true)
        hash = data.first.to_h
        print_error "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
          hash.has_key?('Team') && hash.has_key?('Email')
        data.each do |row|
          username = row['Email']
          @childteams[row['Team']] << username
        end
    end

    def invite
        print_error "csv file, base filename, template repo name, semester prefix, students team name, and gsi team name needed." unless valid?
        first_child_team_name = %Q{#{@semester}-#{@childteams.keys[0]}}

        begin
            parentteam_obj = @client.team_by_name(@orgname, @parentteam)
        rescue Octokit::NotFound
            parentteam_obj = nil
        end

        begin
            if parentteam_obj
                @client.team_by_name(@orgname, first_child_team_name)
                parentteam_id = parentteam_obj['id']
            else
                parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
            end
        rescue Octokit::NotFound
            # students team exists before invite
            # remove all members in this team, and delete the team.
            parentteam_id = parentteam_obj['id']
            old_team_members = @client.team_members(parentteam_id)
            old_team_members.each do |member|
                if @client.organization_membership(@orgname, :user => member['login'])['role'] == 'member'
                    @client.remove_organization_member(@orgname, member['login'])
                end
            end
            @client.delete_team parentteam_id
            parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
        end

        @childteams.each_key do |team|
            childteam_name = %Q{#{@semester}-#{team}}
            begin
                childteam = @client.team_by_name(@orgname, childteam_name)
            rescue Octokit::NotFound
                childteam = @client.create_team(@orgname, {name: %Q{#{@semester}-#{team}}, parent_team_id: parentteam_id})
            end
            childteam_id = childteam['id']
            @childteams[team].each do |member|
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
