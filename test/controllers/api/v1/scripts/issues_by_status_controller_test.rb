# frozen_string_literal: true

require 'test_helper'

class Api::V1::Scripts::IssuesByStatusControllerTest < ActionController::TestCase
  setup do
    @account = send 'public.accounts', :default
    @user    = users :franco
    exp      = 1.month.from_now
    @token   = Api::V1::AuthenticateUser.new(@user, @account).call.result
  end

  test 'return a script without issues' do
    script_without_issues            = scripts :boom
    request.headers['Authorization'] = @token

    get :index

    data_expected = hash_expected_for_script script_without_issues

    assert (data_expected.to_a - response.parsed_body.to_a).empty?
  end

  test 'return a script with some issues' do
    script_with_some_issues          = scripts :ls
    request.headers['Authorization'] = @token

    get :index

    data_expected = hash_expected_for_script script_with_some_issues

    assert (data_expected.to_a - response.parsed_body.to_a).empty?
  end

  test 'return a script with all status issues' do
    script_with_all_status_issues = scripts :ls

    create_issues_with_all_status script_with_all_status_issues

    request.headers['Authorization'] = @token

    get :index

    data_expected = hash_expected_for_script script_with_all_status_issues

    assert (data_expected.to_a - response.parsed_body.to_a).empty?
  end

  private

    def create_issues_with_all_status script
      Issue.statuses.each do |status|
        new_issue = Issue.new description: status, status: status

        if status == 'closed'
          new_tagging = Tagging.new tag: Tag.new(name: 'new final', options: { "final": true })

          new_issue.taggings << new_tagging
        end

        new_issue.owner = script.jobs.first.runs.first

        new_issue.save!
      end
    end

    def hash_expected_for_script script
      { script.name => status_of_issues(script.issues) }
    end

    def status_of_issues issues
      hash_of_status = initialize_hash_of_status.merge issues.group(:status).count

      hash_of_status.deep_transform_keys { |key| I18n.t "issues.status.#{key}" }
    end

    def initialize_hash_of_status
      Issue.statuses.each_with_object({}) { |status, hsh| hsh[status] = 0 }
    end
end
