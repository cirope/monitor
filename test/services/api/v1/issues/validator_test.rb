# frozen_string_literal: true

require 'test_helper'

class Api::V1::Issues::ValidatorTest < ActiveSupport::TestCase
  setup do
    @account = Account.first
    @script  = Script.last
  end

  test 'invalid with non-existent account, invalid script_id' do
    params    = ActionController::Parameters.new(account_id: 'not exist', script_id: 'a')
    validator = Api::V1::Issues::Validator.new(params)

    refute validator.valid?
    assert_equal 404, validator.errors[:code]

    errors = [I18n.t('api.v1.issues.account_not_exist'),
              I18n.t('api.v1.issues.script_incorrect'),
              I18n.t('api.v1.issues.script_not_exist')]

    assert_equal validator.errors[:data], errors
  end

  test 'invalid with non-existent account' do
    params    = ActionController::Parameters.new(account_id: 'not exist', script_id: @script.id)
    validator = Api::V1::Issues::Validator.new(params)

    refute validator.valid?
    assert_equal 404, validator.errors[:code]

    errors = [I18n.t('api.v1.issues.account_not_exist'),
              I18n.t('api.v1.issues.script_not_exist')]

    assert_equal validator.errors[:data], errors
  end

  test 'invalid with non-existent script' do
    params    = ActionController::Parameters.new(account_id: @account.tenant_name, script_id: @script.id + 1)
    validator = Api::V1::Issues::Validator.new(params)

    refute validator.valid?
    assert_equal 404, validator.errors[:code]

    errors = [I18n.t('api.v1.issues.script_not_exist')]

    assert_equal validator.errors[:data], errors
  end

  test 'valid' do
    params    = ActionController::Parameters.new(account_id: @account.tenant_name, script_id: @script.id)
    validator = Api::V1::Issues::Validator.new(params)

    assert validator.valid?
  end
end
