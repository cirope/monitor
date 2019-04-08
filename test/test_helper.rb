# frozen_string_literal: true

require_relative '../config/environment'

require 'rails/test_help'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

Apartment::Tenant.drop    'default' rescue nil
Apartment::Tenant.create  'default'
Apartment::Tenant.switch! 'default'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # Lo comentamos hasta que esté mas pulido
  # parallelize(workers: :number_of_processors)

  fixtures :all

  def assert_error model, attribute, type, options = {}
    error = model.errors.generate_message attribute, type, options

    assert_includes model.errors[attribute], error
  end
end

class ActionController::TestCase
  def login user: users(:franco)
    @controller.send(:cookies).encrypted[:token] = user.auth_token
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
