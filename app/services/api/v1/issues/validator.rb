# frozen_string_literal: true

class Api::V1::Issues::Validator < Api::V1::BaseValidator
  ACCOUNT_NOT_EXIST = I18n.t('api.v1.issues.account_not_exist')
  SCRIPT_INCORRECT  = I18n.t('api.v1.issues.script_incorrect')
  SCRIPT_NOT_EXIST  = I18n.t('api.v1.issues.script_not_exist')

  private

  def validate
    @errors = []
    @errors << ACCOUNT_NOT_EXIST unless exist_account? @params['account_id']
    @errors << SCRIPT_INCORRECT  unless integer? @params['script_id']
    @errors << SCRIPT_NOT_EXIST  unless exist_script? @params['script_id']
    @errors
  end

  def exist_account? account_name
    @account = Account.find_by tenant_name: account_name
    @account.present?
  end

  def exist_script? script_id
    @account.switch { Script.exists? script_id }
  end
end
