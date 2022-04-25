# frozen_string_literal: true

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @comment = comments :possitive
  end

  teardown do
    Current.user = nil
  end

  test 'blank attributes' do
    @comment.text = ''
    @comment.user = nil

    assert @comment.invalid?
    assert_error @comment, :text, :blank
    assert_error @comment, :user, :blank
  end

  test 'validate user belongs to issue' do
    Current.user = users :john

    comment = @comment.dup
    issue   = @comment.issue.dup

    issue.save!

    comment.issue_id = issue.id

    assert comment.invalid?
    assert_error comment, :issue, :invalid
  end

  test 'validates attributes encoding' do
    @comment.text = "\n\t"

    assert @comment.invalid?
    assert_error @comment, :text, :pdf_encoding
  end

  test 'send email after create' do
    Current.user = users :franco

    assert_enqueued_emails 1 do
      @comment.issue.comments.create! text: 'email test'
    end
  end

  test 'do not send email after create if notify is false' do
    Current.user = users :franco

    assert_no_enqueued_emails do
      @comment.issue.comments.create! text: 'email test', notify: false
    end
  end

  test 'owned by' do
    assert @comment.owned_by?(@comment.user)

    assert !@comment.owned_by?(User.new)
  end
end
