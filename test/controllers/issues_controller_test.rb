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

  test 'should show issue' do
    get :show, params: { id: @issue }
    assert_response :success
  end

  test 'should show issue from permalink' do
    permalink = permalinks :link

    get :show, params: { id: permalink.issues.take, permalink_id: permalink }
    assert_response :success
  end

  test 'should get edit' do
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
                file: fixture_file_upload('files/test.sh', 'text/plain', false)
              }
            ]
          }
        }
      end
    end

    assert_redirected_to issue_url(@issue, context: 'issues')
  end

  test 'should destroy issue' do
    assert_difference 'Issue.count', -1 do
      delete :destroy, params: { id: @issue }
    end

    assert_redirected_to script_issues_url(@issue.script)
  end
end
