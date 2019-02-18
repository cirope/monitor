require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

Apartment::Tenant.drop    'default' rescue nil
Apartment::Tenant.create  'default'
Apartment::Tenant.switch! 'default'

class ActiveSupport::TestCase
  set_fixture_class versions: PaperTrail::Version

  fixtures :all

  def assert_error model, attribute, type, options = {}
    error = model.errors.generate_message attribute, type, options

    assert_includes model.errors[attribute], error
  end
end

class ActionController::TestCase
  def login user: users(:franco)
    @controller.send(:cookies).encrypted[:auth_token] = user.auth_token
  end
end

class ActionView::TestCase
  include SimpleForm::ActionViewExtensions::FormHelper
end

class ActiveRecord::FixtureSet
  class << self
    alias :old_create_fixtures :create_fixtures
  end

  def self.create_fixtures f_dir, fs_names, *args
    Membership.delete_all
    Property.delete_all
    Database.delete_all

    reset_cache

    fs_names = %w(public.accounts) | fs_names

    old_create_fixtures f_dir, fs_names, *args
  end
end
