ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'sidekiq/testing/inline'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  fixtures :all

  def assert_error model, attribute, type, options = {}
    assert model.errors[attribute].include?(
      model.errors.generate_message(attribute, type, options)
    )
  end
end

class ActionController::TestCase
  def login user = users(:franco)
    cookies.encrypted[:auth_token] = user.auth_token
  end
end

class ActionView::TestCase
  include SimpleForm::ActionViewExtensions::FormHelper
end
