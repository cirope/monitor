require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @comment = comments :possitive
  end

  test 'blank attributes' do
    @comment.text = ''
    @comment.user = nil

    assert @comment.invalid?
    assert_error @comment, :text, :blank
    assert_error @comment, :user, :blank
  end

  test 'send email after create' do
    PaperTrail.whodunnit = users(:franco).id

    assert_enqueued_emails 1 do
      @comment.issue.comments.create! text: 'email test'
    end
  end

  test 'do not send email after create if notify is false' do
    PaperTrail.whodunnit = users(:franco).id

    assert_no_enqueued_emails do
      @comment.issue.comments.create! text: 'email test', notify: false
    end
  end

  test 'owned by' do
    assert @comment.owned_by?(@comment.user)

    assert !@comment.owned_by?(User.new)
  end
end
