# frozen_string_literal: true

require 'test_helper'

class Tickets::CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments :new_script

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

    assert_redirected_to ticket_url(@comment.issue)
  end
end
