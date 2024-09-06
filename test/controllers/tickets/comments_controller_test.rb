# frozen_string_literal: true

require 'test_helper'

class Tickets::CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments :possitive

    login
  end

  test 'should create comment' do
    assert_difference 'Comment.count' do
      post :create, params: {
        ticket_id: @comment.issue_id,
        comment: {
          text: @comment.text,
          attachment: fixture_file_upload('text.txt')
        }
      }
    end

    assert_redirected_to ticket_url(@comment.issue)
  end

  test 'should show comment' do
    get :show, params: { ticket_id: @comment.issue_id, id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { ticket_id: @comment.issue_id, id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should update comment' do
    patch :update, params: {
      ticket_id: @comment.issue_id,
      id: @comment,
      comment: { text: 'Updated text' }
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should destroy comment' do
    assert_difference 'Comment.count', -1 do
      delete :destroy, params: { ticket_id: @comment.issue_id, id: @comment }, xhr: true, as: :js
    end

    assert_response :success
  end
end
