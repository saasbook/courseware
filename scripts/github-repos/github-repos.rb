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

    def log(msg, type=:info, output_file=nil)
        output_file ||= STDERR if type === :error
        output_file ||= STDOUT
        output_file.puts "[#{type.upcase}]: #{msg}"
    end

    def print_error(msg=nil)
        log(msg, :error) if !msg.nil?
        STDERR.puts $opts
        exit 1
    end

    def read_teams_and_emails_from csv
        data = CSV.parse(IO.read(csv), headers: true)
        hash = data.first.to_h
        print_error "Need at least 'Team' (int) and 'Email' (str) columns in #{csv}" unless
            hash.has_key?('Team') && hash.has_key?('Email')
        log "geting GitHub users.  Please wait..."
        data.each do |row|
            user = { 'email' => row['Email'] }
            if hash.has_key?('GitHub Username')
                username = row['GitHub Username']
                if !(username.nil? || username.empty?)
                    user['username'] = username
                    begin
                        user['uid'] = @client.user(username).id
                    rescue Octokit::NotFound
                        user['username'] = nil
                        log("GitHub Account '#{username}' does not exist.  Using '#{row['email']}' instead")
                    end
                else
                    log "no gh username for user #{row['Email']}; using email instead"
                end
            end
            @childteams[row['Team']] << user
        end
    end

    def invite
        print_error "csv file, base filename, template repo name, semester prefix, students team name, and gsi team name needed." unless valid?
        first_child_team_name = %Q{#{@semester}-#{@childteams.keys[0]}}

        begin
            parentteam_obj = @client.team_by_name(@orgname, @parentteam)
        rescue Octokit::NotFound
            log("could not find parent team '#{@parentteam}' in org '#{@orgname}'", :warn)
            parentteam_obj = nil
        end

        begin
            if parentteam_obj
                @client.team_by_name(@orgname, first_child_team_name)
                parentteam_id = parentteam_obj['id']
            else
                parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
                log "created parent team '#{@parentteam}' in org '#{@orgname}' with privacy 'closed'"
            end
        rescue Octokit::NotFound
            # students team exists before invite
            # remove all members in this team, and delete the team.
            parentteam_id = parentteam_obj['id']
            log "student team '#{@parentteam}' already exists in org '#{@organization}'; recreating..."
            old_team_members = @client.team_members(parentteam_id)
            old_team_members.each do |member|
                username = member['login']
                if @client.organization_membership(@orgname, :user => username)['role'] == 'member'
                    @client.remove_organization_member(@orgname, username)
                    log "removed student '#{username}' from organization '#{@orgname}'"
                end
            end
            @client.delete_team parentteam_id
            log "deleted team '#{@parentteam}' from org '#{@orgname}'"
            parentteam_id = @client.create_team(@orgname, {name: @parentteam, privacy: 'closed'})['id']
            log "created team '#{@parentteam}' with privacy 'closed' in org '#{@orgname}'"
        end

        @childteams.each_key do |team|
            childteam_name = %Q{#{@semester}-#{team}}
            begin
                childteam = @client.team_by_name(@orgname, childteam_name)
            rescue Octokit::NotFound
                childteam = @client.create_team(@orgname, {name: %Q{#{@semester}-#{team}}, parent_team_id: parentteam_id})
                log "created team '#{@semester}-#{team}' as a child of team '#{@parentteam}' in org '#{@orgname}'"
            end
            childteam_id = childteam['id']
            @childteams[team].each do |member|
                if !@client.team_invitations(childteam_id).any? do |invitation|
                    email_invite_exists = invitation.email == member['email']
                    uid_invite_exists = member['uid'] && invitation.login == member['username']
                    email_invite_exists || uid_invite_exists
                end
                    # send invitation
                    payload = {org: @orgname, role: 'direct_member', team_ids: [childteam_id]}
                    if member['uid']
                        payload[:invitee_id] = member['uid']
                    else
                        payload[:email] = member['email']
                    end

                    begin
                        @client.post(%Q{/orgs/#{@orgname}/invitations}, payload)
                        log "invited user '#{member['username'] || member['email']}' to org '#{@orgname}'"
                    rescue Octokit::UnprocessableEntity
                        log "user '#{member['username'] || member['email']}' is already a part of the org '#{@orgname}'"
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
                print_error "students teams information mismatched - could not find team '#{@semester}-#{team}' in org '#{@orgname}'"
            end
            gsiteam_id = @client.team_by_name(@orgname, @gsiteam)['id']
            new_repo_name = %Q{#{@semester}-#{@base_filename}-#{team}}
            if !@client.repository? %Q{#{@orgname}/#{new_repo_name}}
                begin
                    new_repo = @client.create_repository_from_template(%Q{#{@orgname}/#{@template}}, new_repo_name,
                        {owner: @orgname, private: true})
                        log "created repo '#{new_repo_name}' from template '#{@template}' in org '#{@orgname}'"
                rescue Octokit::NotFound
                    print_error "failed to create repo: template not found."
                end
                if @client.add_team_repository(team_id, new_repo['full_name'], {permission: 'push'})
                    log "added repo '#{new_repo_name}' to team '#{@semester}-#{team}' with permission 'push' in org '#{@orgname}'"
                else
                    log("failed to add repo '#{new_repo_name}' to team '#{@semester}-#{team}' with permission 'push' in org '#{@orgname}'", :warn)
                end
                if @client.add_team_repository(gsiteam_id, new_repo['full_name'], {permission: 'admin'})
                    log "added repo '#{new_repo_name}' to team '#{@gsiteam}' with permission 'admin' in org '#{@orgname}'"
                else
                    log("failed to add repo '#{new_repo_name}' to team '#{@gsiteam}' with permission 'admin' in org '#{@orgname}'", :warn)
                end
            end
        end
    end

    def remove
        print_error "csv file, base filename, template repo name, semester prefix, students team name, and gsi team name needed." unless valid?
        # remove and delete all repos from the students team, delete all child teams
        # also cancel all pending invitaions
        @childteams.each_key do |team|
            repo_name = %Q{#{@orgname}/#{@semester}-#{@base_filename}-#{team}}
            if @client.delete_repository(repo_name)
                log "deleted repo '#{@semester}-#{@base_filename}-#{team}' from org #{@orgname}"
            else
                log("failed to delete repo '#{@semester}-#{@base_filename}-#{team}' from org '#{@orgname}'", :warn)
            end
            begin
                childteam_id = @client.team_by_name(@orgname, %Q{#{@semester}-#{team}})['id'] # eg slug fa23-01
            rescue Octokit::NotFound
                log("failed to find find team '#{@semester}-#{team}' in org '#{@orgname}'", :warn)
                next
            end

            # remove students from the student teams
            team_members = @client.team_members(childteam_id)
            team_members.each do |member|
                if @client.organization_membership(@orgname, :user => member['login'])['role'] == 'member'
                    @client.remove_organization_member(@orgname, member['login'])
                    log "removed member '#{member['login']}' from org '#{@orgname}'"
                end
            end

            @client.team_invitations(childteam_id).each do |invitation|
                # cancel all pending invitations
                @client.delete(%Q{/orgs/#{@orgname}/invitations/#{invitation[:id]}})
                log "canceled pending invitation id '#{invitation[:id]}' by team '#{@semester}-#{team}' in org '#{@orgname}'"
            end
            @client.delete_team childteam_id
            log "deleted team '#{@semester}-#{team}' from org '#{@orgname}'"
        end
        # delete students team
        begin
            team_id = @client.team_by_name(@orgname, @parentteam)['id']
            @client.delete_team team_id
            log "deleted team '#{@parentteam}' from org '#{@organization}'"
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
                log("failed to find team '#{@semester}-#{team}' in org '#{@organization}'", :warn)
                next
            end
            @client.remove_team_repository(childteam_id, repo_name)
            log "removed repo '#{@semester}-#{@base_filename}-#{team}' from team '#{@semester}-#{team}' in org '#{@organization}'"
        end
    end
end

main
