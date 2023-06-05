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
    end
    $opts.parse!
    command = ARGV.pop
    case command
    when 'invite' then org.invite
    when 'repos' then org.create_repos 
    when 'remove' then org.remove
    else org.print_error
    end
    puts "Script ends."
end

class OrgManager
    attr_accessor :orgname, :base_filename, :semester, :template, :parentteam 

    def initialize
        @orgname = nil
        @base_filename = nil
        @semester = nil
        @template = nil
        @parentteam = 'cs169a-students'
        @childteams = Hash.new { |hash, key| hash[key] = [] } # teamID => [email1, email2, ...]
        # print_error("GITHUB_ORG_API_KEY not defined in environment") unless (@key = ENV['GITHUB_ORG_API_KEY'])
        @client = Octokit::Client.new(access_token: "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")
    end

    public

    def valid?
        @base_filename && @semester && @childteams.length > 0 && @template
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
          username = row['Username']
          @childteams[row['Team']] << username
        end
    end

    def invite
        print_error "csv file, base filename, template repo name and semester prefix needed." unless valid?
        first_child_team_name = %Q{#{@semester}-#{@childteams.keys[0]}}

        begin
            parentteam_obj = @client.team_by_name(@orgname, @parentteam)
        rescue Octokit::NotFound
            parentteam_obj = nil
        end

        begin
            if parentteam_obj
                @client.team_by_name(@orgname, first_child_team_name)
            end
        rescue Octokit::NotFound
            # cs169a-students team exists before invite
            # remove all members in this team, and delete the team
            parentteam_id = parentteam_obj['id']
            old_team_members = @client.team_members(parentteam_id)
            old_team_members.each do |member|
                @client.remove_organization_member(@orgname, member)
            end
            @client.delete_team parentteam_id
        end

        parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
        @childteams.each_key do |team|
            childteam_name = %Q{#{@semester}-#{team}}
            begin
                childteam = @client.team_by_name(@orgname, childteam_name)
            rescue Octokit::NotFound
                childteam = @client.create_team(@orgname, {name: %Q{#{@semester}-#{team}}, parent_team_id: parentteam_id})
            end
            childteam_id = childteam['id']

            @childteams[team].each do |member|
                if !@client.team_member?(childteam_id, member) && !@client.team_invitations(childteam_id).any? {|invitations| invitations.login == member}
                    @client.add_team_membership(childteam_id, member)
                end
            end
        end
        puts "Run successfully."
    end

    def create_repos
        print_error "csv file, base filename, template repo name and semester prefix needed." unless valid?
        @childteams.each_key do |team|
            begin
                team_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id']
            rescue Octokit::NotFound
                print_error "Team information mismatched."
            end
            new_repo_name = %Q{#{@semester}-#{@base_filename}-#{team}}
            if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
                begin
                    new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name, 
                        {owner: @orgname, private: true})
                rescue Octokit::NotFound
                    print_error "Template not found."
                end
                @client.add_team_repository(team_id, new_repo['full_name'], {permission: 'admin'})
            end
        end
    end

    def remove
        print_error "csv file, base filename, template repo name and semester prefix needed." unless valid?
        # remove students from the cs169a-students team
        @childteams.each_value do |member|
            @client.remove_org_member(@orgname, member)
        end
        # remove and delete all repos from the cs169a-students team, delete all child teams
        @childteams.each_key do |team|
            repo_name = %Q{#{@orgname}/#{@semester}-#{@base_filename}-#{team}}
            childteam_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id'] # eg slug fa23-01
            @client.remove_team_repository(childteam_id, repo_name)
            @client.delete_repository(repo_name)
            @client.delete_team childteam_id
        end
        # delete cs169a-student team
        team_id = @client.team_by_name(@orgname, @parentteam)['id']
        @client.delete_team team_id
    end
    
end

main