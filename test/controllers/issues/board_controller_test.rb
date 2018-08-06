require 'test_helper'

class Issues::BoardControllerTest < ActionController::TestCase
  setup do
    @issue = issues :ls_on_atahualpa_not_well
    request.env['HTTP_REFERER'] = root_url

    login
  end

  test 'should get index' do
    get :index, session: { board_issues: [@issue.id] }
    assert_response :success
    assert_select 'table tbody tr', session[:board_issues].size
    assert_select 'table tbody tr td', text: @issue.description
  end

  test 'should get empty index' do
    get :index
    assert_response :success
    assert_select 'table tbody', false
  end

  test 'should get index on PDF' do
    get :index, session: { board_issues: [@issue.id] }, as: :pdf
    assert_response :success
    assert_equal 'application/pdf', response.content_type
  end

  test 'should add issue to the board via xhr' do
    post :create, params: { filter: { id: @issue.id } }, xhr: true, as: :js
    assert_response :success
    assert_includes session[:board_issues], @issue.id
  end

  test 'should add issue to the board via filter' do
    post :create, params: { filter: { description: @issue.description } }
    assert_response :redirect
    assert_includes session[:board_issues], @issue.id
  end

  test 'should update issues' do
    session[:board_issues] = [@issue.id]

    patch :update, params: {
      issue: { description: 'Updated' }
    }, session: { board_issues: [@issue.id] }
    assert_redirected_to issues_board_url
    assert_equal 'Updated', @issue.reload.description
  end

  test 'should add comment to issues' do
    assert_difference '@issue.comments.count' do
      patch :update, params: {
        issue: {
          comments_attributes: [
            {
              text: 'New comment',
              file: fixture_file_upload('files/test.sh', 'text/plain', false)
            }
          ]
        }
      }, session: { board_issues: [@issue.id] }
    end

    assert_redirected_to issues_board_url
    assert @issue.last_comment.file?
  end

  test 'should replace tags from issues' do
    assert @issue.tags.any? { |tag| tag.id == tags(:important).id }

    assert_no_difference '@issue.tags.count' do
      patch :update, params: {
        issue: {
          taggings_attributes: {
            '0': { tag_id: tags(:final).id }
          }
        }
      }, session: { board_issues: [@issue.id] }
    end

    assert_redirected_to issues_board_url
    assert @issue.reload.tags.all? { |tag| tag.id != tags(:important).id }
  end

  test 'should add subscription to issues' do
    assert_difference '@issue.subscriptions.count' do
      patch :update, params: {
        issue: {
          subscriptions_attributes: {
            '0': { user_id: users(:eduardo).id.to_s }
          }
        }
      }, session: { board_issues: [@issue.id] }
    end

    assert_redirected_to issues_board_url
  end

  test 'should delete issue from board via xhr' do
    delete :destroy, params: {
      filter: { id: @issue.id }
    }, session: {
      board_issues: [@issue.id]
    }, xhr: true, as: :js

    assert_response :success
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should delete issue from board via filter' do
    delete :destroy, params: {
      filter: {
        description: @issue.description
      }
    }, session: { board_issues: [@issue.id] }

    assert_response :redirect
    assert session[:board_issues].exclude?(@issue.id)
  end

  test 'should empty the board' do
    delete :empty, session: {
      board_issues: [@issue.id],
      board_issue_errors: { @issue.id => 'Error' }
    }

    assert_redirected_to dashboard_url
    assert_equal 0, session[:board_issues].size
    assert_equal 0, session[:board_issue_errors].size
  end

  test 'should destroy all issues on the board' do
    issue = @issue.dup

    assert_difference 'Issue.count' do
      issue.save!
    end

    assert_difference 'Issue.count', -1 do
      delete :destroy_all, session: {
        board_issues: [@issue.id],
        board_issue_errors: { @issue.id => 'Error' }
      }
    end

    assert_redirected_to dashboard_url
    assert_equal 0, session[:board_issues].size
    assert_equal 0, session[:board_issue_errors].size
    assert issue.reload
    assert_raise(ActiveRecord::RecordNotFound) { @issue.reload }
  end
end
