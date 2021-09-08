# frozen_string_literal: true

require 'test_helper'

class Api::V1::Issues::ValidatorTest < ActiveSupport::TestCase
  setup do
    @account = Account.first
    @script  = Script.last
  end

  test 'invalid with invalid script_id' do
    params    = ActionController::Parameters.new(script_id: 'a')
    validator = Api::V1::Issues::Validator.new(params)

    refute validator.valid?
    assert_equal 404, validator.errors[:code]

    errors = [I18n.t('api.v1.issues.script_incorrect'),
              I18n.t('api.v1.issues.script_not_exist')]

    assert_equal validator.errors[:data], errors
  end

  test 'invalid with non-existent script' do
    params    = ActionController::Parameters.new(script_id: @script.id + 1)
    validator = Api::V1::Issues::Validator.new(params)

    refute validator.valid?
    assert_equal 404, validator.errors[:code]

    errors = [I18n.t('api.v1.issues.script_not_exist')]

    assert_equal validator.errors[:data], errors
  end

  test 'valid' do
    params    = ActionController::Parameters.new(script_id: @script.id)
    validator = Api::V1::Issues::Validator.new(params)

    assert validator.valid?
  end
end
