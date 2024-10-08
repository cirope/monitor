# frozen_string_literal: true

require 'test_helper'

class ConsoleControllerTest < ActionController::TestCase
  test 'should get show' do
    skip # unless ENABLE_WEB_CONSOLE

    login

    get :show
    assert_response :success
  end

  test 'should be redirected if disabled' do
    skip if ENABLE_WEB_CONSOLE

    login

    get :show
    assert_redirected_to login_url
  end
end
