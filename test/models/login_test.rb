# frozen_string_literal: true

require 'test_helper'

class LoginTest < ActiveSupport::TestCase
  setup do
    @login = logins :franco
  end

  test 'blank attributes' do
    @login.user = nil

    assert @login.invalid?
    assert_error @login, :user, :required
  end
end
