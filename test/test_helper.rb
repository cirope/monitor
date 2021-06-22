# frozen_string_literal: true

require_relative '../config/environment'

require 'rails/test_help'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

require 'minitest/reporters'
Minitest::Reporters.use!

Apartment::Tenant.drop    'default' rescue nil
Apartment::Tenant.create  'default'
Apartment::Tenant.switch! 'default'

Serie.create_tenant 'default'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # Commented out until further _polishment_
  parallelize(workers: 1)

  set_fixture_class versions: PaperTrail::Version

  fixtures :all

  def assert_error model, attribute, type, options = {}
    error = model.errors.generate_message attribute, type, options

    assert_includes model.errors[attribute], error
  end

  def stub_any_instance(klass, method, value)
    klass.class_eval do
      alias_method :"old_#{method}", method

      define_method method do |*args|
        value
      end
    end

    yield
  ensure
    klass.class_eval do
      undef_method method
      alias_method method, :"old_#{method}"
      undef_method :"old_#{method}"
    end
  end
end

class ActionController::TestCase
  def login user: users(:franco)
    @controller.send(:cookies).encrypted[:token] = user.auth_token
  end
end

class ActionView::TestCase
  include FontAwesome::Sass::Rails::ViewHelpers
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

    fs_names         = %w(public.accounts) | fs_names
    apartment_models = Apartment.excluded_models.map &:constantize

    apartment_models.each do |model|
      alter_sql = "ALTER TABLE #{model.quoted_table_name} DISABLE TRIGGER ALL"

      ActiveRecord::Base.connection.execute alter_sql
    end

    fixtures_result = old_create_fixtures f_dir, fs_names, *args

    apartment_models.each do |model|
      alter_sql = "ALTER TABLE #{model.quoted_table_name} ENABLE TRIGGER ALL"

      ActiveRecord::Base.connection.execute alter_sql
    end

    fixtures_result
  end
end
