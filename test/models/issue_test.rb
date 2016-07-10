require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @issue = issues :ls_on_atahualpa_not_well
  end

  teardown do
    PaperTrail.whodunnit = nil
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

  test 'empty final tag validation' do
    @issue.status = 'closed'

    assert @issue.invalid?
    assert_error @issue, :tags, :invalid
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
    @issue.taggings.create! tag_id: tags(:final).id

    assert_equal %w(pending taken closed), @issue.next_status

    @issue.update! status: 'taken'
    assert_equal %w(taken closed), @issue.next_status

    @issue.update! status: 'closed'
    assert_equal %w(closed), @issue.next_status

    PaperTrail.whodunnit = users(:franco).id

    assert_equal %w(taken closed), @issue.next_status
  end

  test 'notify to' do
    assert_emails 1 do
      @issue.notify_to 'test@monitor.com'
    end
  end

  test 'tagged with' do
    tag    = tags :important
    issues = Issue.tagged_with tag.name

    assert_not_equal 0, issues.count
    assert_not_equal 0, issues.take.tags.count
    assert issues.all? { |issue| issue.tags.any? { |t| t.name == tag.name } }
  end

  test 'by created at' do
    skip
  end

  test 'by data' do
    skip
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
end
