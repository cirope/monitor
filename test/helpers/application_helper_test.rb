# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'app name' do
    assert_kind_of String, app_name
  end

  test 'title' do
    @title = 'test page'

    assert_equal [app_name, @title].join(' | '), title
  end

  test 'account' do
    set_account

    assert_equal [app_name, current_account.name].join(' | '), title
  end

  test 'logo title' do
    set_account

    expected = [current_account.name, MonitorApp::Application::VERSION].join ' | '

    assert_equal expected, logo_title
  end

  private

    def current_account
      @current_account
    end

    def set_account account = send('public.accounts', :default)
      @current_account = account
    end
end
