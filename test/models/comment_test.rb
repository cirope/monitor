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

  test 'destroy' do
    Current.user = users :franco

    file = Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/text.txt", 'text/plain'
    )
    comment = @comment.issue.comments.create! text: 'email test', notify: false, attachment: file

    assert_difference 'Comment.count', -1 do
      assert_difference 'ActiveStorage::Blob.count', -1 do
        comment.destroy!
      end
    end
  ensure
    Current.user = nil
  end

  test 'validate user' do
    Current.user = users :eduardo
    issue        = issues :ls_on_atahualpa_not_well

    issue.comments.new text: 'New comment'

    assert_not issue.valid?

    ticket = tickets :ticket_script

    ticket.title = 'New script'

    ticket.comments.new text: 'New comment'

    assert ticket.valid?
  end
end
