ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  set_fixture_class versions: PaperTrail::Version

  fixtures :all

  def assert_error model, attribute, type, options = {}
    assert model.errors[attribute].include?(
      model.errors.generate_message(attribute, type, options)
    )
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
