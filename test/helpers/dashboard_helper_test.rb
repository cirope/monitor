require 'test_helper'

class DashboardHelperTest < ActionView::TestCase
  test 'filters?' do
    assert !filters?

    params[:filter] = { name: '  ' }

    assert !filters?

    params[:filter] = { name: 'something' }

    assert filters?
  end

  test 'dashboard empty message' do
    @virtual_path = ''

    assert_kind_of String, dashboard_empty_message
  end

  test 'script issue count' do
    script = scripts :ls

    assert_equal script.active_issues_count, script_issue_count(script)
  end

  test 'script issue count with filter' do
    @filter = true
    script  = scripts :ls

    assert_equal script.issues.filter(issue_filter).count, script_issue_count(script)
  end

  test 'filter status' do
    assert_respond_to filter_status, :each
  end

  private

    def issue_filter
      @filter ? { tags: tags(:important).name } : {}
    end
end
