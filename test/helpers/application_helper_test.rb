require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'app name' do
    ENV['APP_NAME'] = 'Test'

    assert_equal ENV['APP_NAME'], app_name
  end

  test 'title' do
    @title = 'test page'

    assert_equal [app_name, @title].join(' | '), title
  end
end
