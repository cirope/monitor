# frozen_string_literal: true

require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @issue = issues :ls_on_atahualpa_not_well
  end

  teardown do
    PaperTrail.request.whodunnit = nil
  end

  test 'blank attributes' do
    @issue.status = ''

    assert @issue.invalid?
    assert_error @issue, :status, :blank
  end

  test 'included attributes' do
    @issue.status = 'wrong'

    assert @issue.invalid?
    assert_error @issue, :status, :inclusion
  end

  test 'validates attributes encoding' do
    @issue.description = "\n\t"

    assert @issue.invalid?
    assert_error @issue, :description, :pdf_encoding
  end

  test 'empty final tag validation' do
    @issue.status = 'closed'

    assert @issue.invalid?
    assert_error @issue, :tags, :invalid
  end

  test 'user can modify' do
    PaperTrail.request.whodunnit = users(:eduardo).id

    assert @issue.invalid?
    assert_error @issue, :base, :user_invalid
  end

  test 'more than one final tag validation' do
    tag = Tag.create! name: 'new final tag', options: { final: true }

    @issue.taggings.create! tag_id: tags(:final).id
    @issue.taggings.create! tag_id: tag.id

    @issue.status = 'closed'

    assert @issue.invalid?
    assert_error @issue, :tags, :invalid
  end

  test 'next status' do
    PaperTrail.request.whodunnit = nil

    @issue.taggings.create! tag_id: tags(:final).id

    assert_equal %w(pending taken closed), @issue.next_status

    @issue.update! status: 'taken'
    assert_equal %w(taken closed), @issue.next_status

    @issue.update! status: 'closed'
    assert_equal %w(closed), @issue.next_status

    PaperTrail.request.whodunnit = users(:franco).id

    assert_equal %w(taken closed), @issue.next_status
  end

  test 'notify to' do
    assert_enqueued_emails 1 do
      @issue.notify_to 'test@monitor.com'
    end
  end

  test 'permissions' do
    assert !@issue.can_be_edited_by?(users(:god))
    # And here the evidence... I have more power than God
    assert  @issue.can_be_edited_by?(users(:franco))

    assert !@issue.can_be_edited_by?(users(:eduardo))
    assert !@issue.can_be_light_edited_by?(users(:eduardo))

    @issue.subscriptions.clear
    @issue.subscriptions.create! user_id: users(:eduardo).id

    assert @issue.reload.can_be_edited_by?(users(:eduardo))

    assert !@issue.can_be_edited_by?(users(:john))

    @issue.subscriptions.create! user_id: users(:john).id

    assert !@issue.reload.can_be_edited_by?(users(:john))
    assert  @issue.reload.can_be_light_edited_by?(users(:john))
  end

  test 'tagged with' do
    tag    = tags :important
    issues = Issue.tagged_with tag.name

    assert_not_equal 0, issues.count
    assert_not_equal 0, issues.take.tags.count
    assert issues.all? { |issue| issue.tags.any? { |t| t.name == tag.name } }
  end

  test 'not tagged' do
    Issue.take.tags.clear

    issues = Issue.not_tagged

    assert_not_equal 0, issues.count
    assert issues.all? { |issue| issue.tags.empty? }
  end

  test 'by created at' do
    skip
  end

  test 'by data' do
    skip
  end

  test 'by user id' do
    user   = users :john
    issues = Issue.by_user_id(user.id)

    assert_not_equal 0, issues.count
    assert issues.all? { |issue| issue.users.include?(user) }
  end

  test 'by comment' do
    issues = Issue.by_comment('wat')

    assert_not_equal 0, issues.count
    assert issues.all? { |issue| issue.comments.any? { |c| c.text =~ /wat/i } }
  end

  test 'pending?' do
    assert @issue.pending?

    @issue.status = 'taken'

    assert !@issue.pending?
  end

  test 'export issue data' do
    path = @issue.export_data

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'export data' do
    path = Issue.export_data

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'add to zip' do
    skip
  end

  test 'to pdf' do
    path = Issue.to_pdf

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'comment' do
    user                         = users :franco
    PaperTrail.request.whodunnit = user.id

    assert user.issues.any?

    assert_enqueued_emails user.issues.count do
      user.issues.comment text: 'Mass comment test'
    end
  end
end
