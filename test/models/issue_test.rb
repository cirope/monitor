# frozen_string_literal: true

require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  setup do
    @issue = issues :ls_on_atahualpa_not_well
  end

  teardown do
    Current.account = nil
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

  test 'requires comment' do
    Current.user = users :eduardo

    Current.user.update! role: 'owner'

    @issue.status = 'taken'

    assert @issue.invalid?
    assert_error @issue, :comments, :blank
  ensure
    Current.user = nil
  end

  test 'user can modify' do
    Current.user = users :eduardo

    assert @issue.invalid?
    assert_error @issue, :base, :user_invalid
  ensure
    Current.user = nil
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
    Current.user = nil

    @issue.taggings.create! tag_id: tags(:final).id

    assert_equal %w(pending taken revision closed), @issue.next_status

    @issue.update! status: 'taken'
    assert_equal %w(taken revision closed), @issue.next_status

    @issue.update! status: 'revision'
    assert_equal %w(revision closed), @issue.next_status

    @issue.update! status: 'closed'
    assert_equal %w(closed), @issue.next_status

    Current.user = users :franco

    assert_equal %w(taken revision closed), @issue.next_status

    @issue.update! status: 'taken'

    Current.user      = users :john
    Current.user.role = 'owner'

    assert_equal %w(taken revision), @issue.next_status

    @issue.update! status: 'revision', comments_attributes: [{ text: 'Test' }]
    assert_equal %w(revision), @issue.next_status
  ensure
    Current.user = nil
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

  test 'converted data' do
    @issue.data = { key1: 1, key2: [[:h1, :h2], ['v1', 'v2'], ['v3', 'v4']] }
    expected    = {
      'key1' => 1,
      'key2' => [{ 'h1' => 'v1', 'h2' => 'v2' }, { 'h1' => 'v3', 'h2' => 'v4' }]
    }

    assert_equal expected, @issue.converted_data

    @issue.data = [
      'single',
      [[:h1, :h2], ['v1', 'v2'], ['v3', 'v4']],
      { key1: 1, key2: [[:h1, :h2], ['v1', 'v2']] }
    ]
    expected    = [
      'single',
      [{ 'h1' => 'v1', 'h2' => 'v2' }, { 'h1' => 'v3', 'h2' => 'v4' }],
      { 'key1' => 1, 'key2' => [{ 'h1' => 'v1', 'h2' => 'v2' }]}
    ]

    assert_equal expected, @issue.converted_data

    @issue.data = [[:h1, :h2], ['v1', 'v2'], ['v3', 'v4']]
    expected    = [
      { 'h1' => 'v1', 'h2' => 'v2' },
      { 'h1' => 'v3', 'h2' => 'v4' }
    ]

    assert_equal expected, @issue.converted_data

    @issue.data = { h1: 'v1', h2: 'v2' }
    expected    = { 'h1' => 'v1', 'h2' => 'v2' }

    assert_equal expected, @issue.converted_data

    @issue.data = 1

    assert_equal 1, @issue.converted_data

    @issue.data = nil

    assert_nil @issue.converted_data
  end

  test 'data type' do
    @issue.update! data: nil

    assert @issue.empty_data_type?

    @issue.update! data: { some: 'data' }

    assert @issue.object_data_type?

    @issue.update! data: [['Header'], ['Value']]

    assert @issue.single_row_data_type?

    @issue.update! data: [{ header: 'value' }]

    assert @issue.single_row_data_type?
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

  test 'tag with implied' do
    tag = tags :important

    @issue.tags.clear

    assert_difference '@issue.tags.count', 2 do
      @issue.taggings.create! tag: tag
    end

    assert_equal tags(:important, :final).map(&:id).sort,
                 @issue.reload.tags.ids.sort
  end

  test 'tag with implied on new issue' do
    tag   = tags :important
    issue = @issue.dup

    issue.taggings.build tag: tag

    assert_difference 'Issue.count' do
      assert_difference 'Tagging.count', 2 do
        issue.save!
      end
    end

    assert_equal tags(:important, :final).map(&:id).sort,
                 issue.reload.tags.ids.sort
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

  test 'by scheduled_at' do
    (runs :boom_on_atahualpa).issues << Issue.new(status: 'pending')

    run_to_query = runs :past_ls_on_atahualpa

    from_date = (run_to_query.scheduled_at - 1.minutes).strftime('%d/%m/%Y%k:%M')

    to_date   = (run_to_query.scheduled_at + 1.minutes).strftime('%d/%m/%Y%k:%M')

    issues = Issue.by_scheduled_at("#{from_date} - #{to_date}")

    assert_equal run_to_query.issues.count, issues.count
  end

  test 'pending?' do
    assert @issue.pending?

    @issue.status = 'taken'

    assert !@issue.pending?
  end

  test 'export issue data' do
    Current.account = send 'public.accounts', :default
    file_content    = @issue.export_content

    assert_not_nil file_content
  end

  test 'export issue without data' do
    Current.account = send 'public.accounts', :default

    @issue.data  = {}
    file_content = @issue.export_content

    assert_nil file_content
  end

  test 'export data' do
    Current.account = send 'public.accounts', :default
    path            = Issue.export

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'export grouped data' do
    Current.account = send 'public.accounts', :default
    path            = Issue.grouped_export

    assert File.exist? path

    grouped_zip = Zip::File.open path, Zip::File::CREATE

    assert_equal 1, grouped_zip.entries.size
    assert_equal 'Execute_one_ls.zip', grouped_zip.entries.first.name

    raw_issues = grouped_zip.read 'Execute_one_ls.zip'

    tmp_file = Tempfile.open do |temp|
      temp.binmode
      temp << raw_issues
      temp.path
    end

    issues = Zip::File.open tmp_file, Zip::File::CREATE

    assert_equal 1, issues.entries.size

    csv_report = issues.read 'Execute_one_ls.csv'

    csv = CSV.parse csv_report[3..-1], col_sep: ';', force_quotes: true, headers: true

    assert_equal csv.size, Issue.all.count

    FileUtils.rm_f path
  end

  test 'add to zip' do
    skip
  end

  test 'can collapse data' do
    skip
  end

  test 'to pdf' do
    Current.account = send 'public.accounts', :default
    path            = Issue.to_pdf

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'to csv' do
    Current.account = send 'public.accounts', :default
    path            = Issue.to_csv

    assert File.exist?(path)

    old_size = File.size(path)

    FileUtils.rm path

    path = Issue.where(data_type: 'single_row').to_csv

    assert File.exist?(path)
    assert_not_equal old_size, File.size(path)

    FileUtils.rm path
  end

  test 'comment' do
    Current.user = user = users :franco

    assert user.issues.any?

    assert_enqueued_emails user.issues.count do
      user.issues.comment text: 'Mass comment test'
    end
  ensure
    Current.user = nil
  end

  test 'return issues with script scoped' do
    script = @issue.script

    assert_equal script.issues.order(:id), Issue.script_scoped(script).order(:id)
  end

  test 'return issues with script_id scoped' do
    script = @issue.script

    assert_equal script.issues.order(:id), Issue.script_id_scoped(script.id).order(:id)
  end

  test 'url' do
    account         = Account.first
    Current.account = account

    url = Rails.application
               .routes
               .url_helpers
               .account_issue_url(account, @issue, host: ENV['APP_HOST'], protocol: ENV['APP_PROTOCOL'])

    assert_equal url, @issue.url
  end

  test 'should store state transition' do
    @issue.update! status: 'taken'

    assert @issue.reload.state_transitions['taken'].present?
  end

  test 'check status changed and update states reminders' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well

    reminder.update! transition_rules: { 'status_changed': { 'taken': 'done' } }

    @issue.update! status: 'taken'

    assert_equal 'done', reminder.reload.state_class_type
  end

  test 'check status changed and not update states reminders' do
    reminder = reminders :reminder_of_ls_on_atahualpa_not_well

    reminder.update! transition_rules: { 'status_changed': { 'taken': 'test' } }

    @issue.update! status: 'taken'

    assert_equal 'pending', reminder.reload.state_class_type
  end

  test 'should update canonical data' do
    @issue.update! data: [[:h1, :h2], ['v1', 'v2']]

    expected = { 'h1' => 'v1', 'h2' => 'v2' }

    assert_equal expected, @issue.reload.canonical_data

    @issue.update! data: { key1: 1, key2: [[:h1, :h2], ['v1', 'v2'], ['v3', 'v4']] }

    assert_nil @issue.reload.canonical_data

    @issue.update! data: [{ h1: 'v1', h2: 'v2' }]

    expected = { 'h1' => 'v1', 'h2' => 'v2' }

    assert_equal expected, @issue.reload.canonical_data

    @issue.update! data: nil

    assert_nil @issue.reload.canonical_data
  end

  test 'should return a issue with like canonical data' do
    @issue.update! data: [[:k1, :k2, :k3], ['value1', 'value2', 'value1']]

    another_issue = issues :ls_on_atahualpa_not_well_again

    another_issue.update! data: [[:k1, :k2, :k3], ['value2', 'value1', 'value2']]

    keys_orderd_json = ['k1', 'k2', 'k3'].to_json

    data_keys = { 'k3' => nil, 'k2' => nil, 'k1' => 'lue1', keys_ordered: keys_orderd_json }

    issues = Issue.by_canonical_data(data_keys)

    assert_equal 1, issues.count
    assert_equal @issue.id, issues.first.id

    data_keys = { 'k3' => nil, 'k2' => nil, 'k1' => 'lue2', keys_ordered: keys_orderd_json }

    issues = Issue.by_canonical_data(data_keys)

    assert_equal 1, issues.count
    assert_equal another_issue.id, issues.first.id
  end

  test 'should return view by user' do
    issue = issues :ls_on_atahualpa_not_well

    assert_equal views(:franco_view_ls), issue.view_by(users :franco)
  end

  test 'should return issues grouped by views for current user' do
    Subscription.create! issue: issues(:ls_on_atahualpa_not_well_again),
                         user: users(:franco)

    current_user    = users :franco
    expected_return = Issue.left_joins(:views)
                           .group("#{View.table_name}.user_id")
                           .merge(View.viewed_by(current_user).or(View.where(user_id: nil)))
                           .count

    assert_equal expected_return, Issue.grouped_by_views(current_user).count
  end

  test 'should return issues grouped by script and views for current user' do
    Subscription.create! issue: issues(:ls_on_atahualpa_not_well_again),
                         user: users(:franco)

    current_user    = users :franco
    schedule        = schedules :ls_on_atahualpa
    expected_return = Issue.grouped_by_script(schedule.id)
                           .grouped_by_views(current_user)
                           .count

    assert_equal expected_return, Issue.grouped_by_script_and_views(schedule.id, current_user).count
  end

  test 'should return issues grouped by schedule and views for current user' do
    Subscription.create! issue: issues(:ls_on_atahualpa_not_well_again),
                         user: users(:franco)

    current_user    = users :franco
    expected_return = Issue.grouped_by_schedule
                           .grouped_by_views(current_user)
                           .count

    assert_equal expected_return, Issue.grouped_by_schedule_and_views(current_user).count
  end
end
