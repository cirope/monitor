require 'test_helper'

class IssuesControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper

  setup do
    @issue = issues :ls_on_atahualpa_not_well

    login
  end

  test 'should get index' do
    get :index, script_id: @issue.script.id
    assert_response :success
    assert_not_nil assigns(:issues)
    assert assigns(:issues).any?
  end

  test 'should get filtered index' do
    get :index, script_id: @issue.script.id, filter: { description: 'undefined' }
    assert_response :success
    assert_not_nil assigns(:issues)
    assert assigns(:issues).empty?
  end

  test 'should get index as guest' do
    user = users(:john)

    login user

    get :index
    assert_response :success
    assert_not_nil assigns(:issues)
    assert assigns(:issues).all? { |issue| issue.users.find user.id }
  end

  test 'should get fixed index' do
    issue_ids = Issue.all.pluck 'id'

    get :index, ids: issue_ids.join('|')
    assert_response :success
    assert_not_nil assigns(:issues)
    assert assigns(:issues).all? { |issue| issue_ids.include? issue.id }
  end

  test 'should show issue' do
    get :show, id: @issue
    assert_response :success
  end

  test 'should show issue from permalink' do
    permalink = permalinks :link

    get :show, id: permalink.issues.take, permalink_id: permalink
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @issue
    assert_response :success
  end

  test 'should update issue' do
    assert_emails 1 do
      assert_difference ['Subscription.count', 'Comment.count', 'Tagging.count'] do
        patch :update, id: @issue, issue: {
          status: 'taken',
          subscriptions_attributes: [
            { user_id: users(:john).id.to_s }
          ],
          taggings_attributes: [
            {
              tag_id: tags(:important).id.to_s
            }
          ],
          comments_attributes: [
            {
              text: 'test comment',
              file: fixture_file_upload('files/test.sh', 'text/plain', false)
            }
          ]
        }
      end
    end

    assert_redirected_to issue_url(assigns(:issue))
  end

  test 'should destroy issue' do
    assert_difference 'Issue.count', -1 do
      delete :destroy, id: @issue
    end

    assert_redirected_to script_issues_url(@issue.script)
  end
end
