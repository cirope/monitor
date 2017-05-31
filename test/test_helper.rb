require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class ActiveSupport::TestCase
  set_fixture_class versions: PaperTrail::Version

  fixtures :all

  def assert_error model, attribute, type, options = {}
    error = model.errors.generate_message attribute, type, options

    assert_includes model.errors[attribute], error
  end
end

class ActionController::TestCase
  def login user = users(:franco)
    @controller.send(:cookies).encrypted[:auth_token] = user.auth_token
  end
end

class ActionView::TestCase
  include SimpleForm::ActionViewExtensions::FormHelper
end
