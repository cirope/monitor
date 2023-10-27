# frozen_string_literal: true

require 'test_helper'

class Issues::CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments :possitive

    login
  end

  test 'should create comment' do
    assert_difference 'Comment.count' do
      post :create, params: {
        issue_id: @comment.issue_id,
        comment: {
          text: @comment.text,
          attachment: fixture_file_upload('text.txt')
        }
      }
    end

    assert_redirected_to issue_url(@comment.issue)
  end

  test 'should show comment' do
    get :show, params: { issue_id: @comment.issue_id, id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { issue_id: @comment.issue_id, id: @comment }, xhr: true, as: :js
    assert_response :success
  end

  test 'should update comment' do
    patch :update, params: {
      issue_id: @comment.issue_id,
      id: @comment,
      comment: { text: 'Updated text' }
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should destroy comment' do
    Current.user = users :franco
    file         = fixture_file_upload('text.txt')
    comment      = @comment.issue.comments.create!(text: 'asdfads')

    comment.attachment.attach(io: file, filename: 'text.txt')

    assert comment.attachment.attached?

    comment.destroy

    assert_not Comment.exists?(comment.id)
    assert_not comment.attachment.attached?
    assert_response :success
  ensure
    Current.user = nil
  end
end
