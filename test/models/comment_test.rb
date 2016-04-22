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

    assert_emails 1 do
      @comment.issue.comments.create! text: 'email test'
    end

    email = ActionMailer::Base.deliveries.last

    assert email.to.any?
    assert email.to.exclude?(@comment.user.email)
  end

  test 'do not send email after create if notify is false' do
    PaperTrail.whodunnit = users(:franco).id

    assert_no_emails do
      @comment.issue.comments.create! text: 'email test', notify: false
    end
  end
end
