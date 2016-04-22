require 'test_helper'

class DashboardHelperTest < ActionView::TestCase
  test 'filter status' do
    assert_respond_to filter_status, :each
  end

  private

    def issue_filter
      @filter ? { tags: tags(:important).name } : {}
    end
end
