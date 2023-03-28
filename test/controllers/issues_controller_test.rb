# frozen_string_literal: true

require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper

  setup do
    @issue = issues :ls_on_atahualpa_not_well

    login
  end

  test 'should get index' do
    get :index, params: { script_id: @issue.script.id }
    assert_response :success
    assert_select 'a[href*=?]', 'partial=alt', count: 0
  end

  test 'should get index csv' do
    assert_nothing_raised do
      get :index, params: { script_id: @issue.script.id }, format: :csv
    end

    assert_response :success
    assert_equal 'text/csv', response.content_type
  end

  test 'should get alt index' do
    @issue.script.issues.each do |issue|
      issue.update! data: [['Header one', 'Header two'], ['Value 1', 'Value 2']]
    end

    get :index, params: { script_id: @issue.script.id }
    assert_response :success
    assert_select 'a[href*=?]', 'partial=alt', count: 1
  end

  test 'should get alt index filtered canonical data' do
    @issue.script.issues.each do |issue|
      issue.update! data: [['Header one', 'Header two'], ['Value 1', 'Value 2']]
    end

    get :index, params: {
      script_id: @issue.script.id,
      filter: {
        canonical_data: {
          'Header one': 'lue',
          keys_ordered: @issue.reload.canonical_data.keys.to_json
        }
      }
    }
    assert_response :success
    assert_select 'a[href*=?]', 'partial=alt', count: 1
  end

  test 'should get empty alt index filtered canonical data' do
    @issue.script.issues.each do |issue|
      issue.update! data: [['Header one', 'Header two'], ['Value 1', 'Value 2']]
    end

    get :index, params: {
      script_id: @issue.script.id,
      filter: {
        canonical_data: {
          'Header one': 'test',
          keys_ordered: @issue.reload.canonical_data.keys.to_json
        }
      }
    }
    assert_response :success
    assert_select '.alert', text: I18n.t('issues.index.empty_search_html')
  end

  test 'should get filtered index' do
    get :index, params: {
      script_id: @issue.script.id,
      filter: { description: 'undefined', user: 'none', user_id: '1' }
    }
    assert_response :success
    assert_select '.alert', text: I18n.t('issues.index.empty_search_html')
  end

  test 'should get filtered index using issue user' do
    user = @issue.users.take!

    get :index, params: {
      script_id: @issue.script.id,
      filter: { user: user.to_s, user_id: user.id }
    }
    assert_response :success
    assert_select 'table tbody'
  end

  test 'should get index as guest' do
    user = users :john

    login user: user

    get :index
    assert_response :success
  end

  test 'should get index graph variants' do
    @issue.script.issues.each do |issue|
      issue.update! data: [['Header one', 'Header two'], ['Value 1', 'Value 2']]
    end

    %w(status tags final_tags other).each do |graph|
      get :index, params: { script_id: @issue.script.id, graph: graph }
      assert_response :success
      assert_equal [:graph], @request.variant
    end
  end

  test 'should show issue' do
    get :show, params: { id: @issue }
    assert_response :success
  end

  test 'should show issue from permalink' do
    permalink = permalinks :link

    get :show, params: { id: permalink.issues.take, permalink_id: permalink }
    assert_response :success
  end

  test 'should show issue with account' do
    account = send 'public.accounts', :default

    get :show, params: { id: @issue, account_id: account }

    assert account.tenant_name, session[:tenant_name]
    assert_redirected_to issue_url(@issue)
  end

  test 'should show script issues with account' do
    account = send 'public.accounts', :default

    get :index, params: { script_id: @issue.script.id, account_id: account }

    assert account.tenant_name, session[:tenant_name]
    assert_redirected_to script_issues_url(@issue.script)
  end

  test 'should get edit' do
    get :edit, params: { id: @issue }
    assert_response :success
  end

  test 'should get edit as owner' do
    user = users :john

    user.update! role: roles(:owner)

    login user: user

    get :edit, params: { id: @issue }
    assert_response :success
  end

  test 'should update issue' do
    assert_enqueued_emails 1 do
      assert_difference ['Subscription.count', 'Comment.count', 'Tagging.count'] do
        patch :update, params: {
          id: @issue,
          issue: {
            status: 'taken',
            subscriptions_attributes: [
              { user_id: users(:eduardo).id.to_s }
            ],
            taggings_attributes: [
              {
                tag_id: tags(:final).id.to_s
              }
            ],
            comments_attributes: [
              {
                text: 'test comment',
                file: fixture_file_upload('test/fixtures/files/test.sh', 'text/plain', false)
              }
            ]
          }
        }
      end
    end

    assert_redirected_to issue_url(@issue, context: 'issues')
  end

  test 'should update issue as owner' do
    user = users :john

    user.update! role: roles(:owner)

    login user: user

    assert_enqueued_emails 1 do
      assert_no_difference ['Subscription.count', 'Tagging.count'] do
        assert_difference 'Comment.count' do
          patch :update, params: {
            id: @issue,
            issue: {
              status: 'taken',
              description: 'This text should not be used',
              subscriptions_attributes: [
                { user_id: users(:eduardo).id.to_s }
              ],
              taggings_attributes: [
                {
                  tag_id: tags(:final).id.to_s
                }
              ],
              comments_attributes: [
                {
                  text: 'test comment',
                  file: fixture_file_upload('test/fixtures/files/test.sh', 'text/plain', false)
                }
              ]
            }
          }
        end
      end
    end

    assert_redirected_to issue_url(@issue, context: 'issues')
    assert_not_equal 'This text should not be used', @issue.reload.description
  end

  test 'should destroy issue' do
    assert_difference 'Issue.count', -1 do
      delete :destroy, params: { id: @issue }
    end

    assert_redirected_to script_issues_url(@issue.script)
  end

  test 'should respond api issues' do
    script = scripts :ls

    post :api_issues, params: { script_id: script.id }, as: :js

    url = api_v1_script_issues_url script.id,
                                   host: ENV['APP_HOST'],
                                   protocol: ENV['APP_PROTOCOL']

    assert_match url, response.body
  end

  test 'return filter params' do
    @issue.update! data: [{ "test": 'data' }]

    keys_ordered = issues.first.canonical_data.keys

    params_hash = {
      id: @issue.id,
      name: 'test',
      description: @issue.description,
      status: @issue.status,
      user: 'test',
      user_id: @issue.users.first.id,
      show: 'test',
      tags: @issue.tags.to_s,
      data: @issue.data.to_s,
      comment: @issue.comments.first.text,
      key: @issue.data.first.first,
      created_at: @issue.created_at,
      scheduled_at: @issue.schedule.scheduled_at,
      canonical_data: ActionController::Parameters.new(@issue.reload
                                                             .canonical_data
                                                             .merge(keys_ordered: keys_ordered)),
      no_return: 'no return'
    }

    @controller.params = ActionController::Parameters.new({ filter: params_hash })

    assert_equal ActionController::Parameters.new(params_hash).permit(Issues::Filters::PERMITED_FILTER_PARAMS), 
                 @controller.send(:filter_params)
  end
end
