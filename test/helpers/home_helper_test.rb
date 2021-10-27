# frozen_string_literal: true

require 'test_helper'

class HomeHelperTest < ActionView::TestCase
  test 'filter status' do
    assert_respond_to filter_status, :each
  end

  test 'owner options' do
    assert_respond_to owner_options, :each
  end

  test 'filter query hash' do
    assert_kind_of Hash, filter_query_hash
  end

  test 'link to api issues by status' do
    button = link_to_api_issues_by_status

    assert_match home_api_issues_by_status_path, button
  end

  private


    def issue_filter
      {}
    end

    def filter_params
      {}
    end
end
