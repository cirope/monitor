require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments :possitive

    login
  end

  test 'should create comment' do
    assert_difference 'Comment.count' do
      post :create, params: {
        comment: {
          text:     @comment.text,
          issue_id: @comment.issue_id
        }
      }
    end

    assert_redirected_to issue_url(@comment.issue)
  end

  test 'should show comment' do
    get :show, params: { id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should update comment' do
    patch :update, params: {
      id: @comment,
      comment: { text: 'Updated text' }
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should destroy comment' do
    assert_difference('Comment.count', -1) do
      delete :destroy, params: { id: @comment }, xhr: true, as: :js
    end

    assert_response :success
  end
end
