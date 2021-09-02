# frozen_string_literal: true

class Api::V1::Issues::Validator < Api::V1::BaseValidator
  private

    def validate
      @errors = []

      @errors << I18n.t('api.v1.issues.script_incorrect')  unless integer? @params['script_id']
      @errors << I18n.t('api.v1.issues.script_not_exist')  unless script_exist? @params['script_id']

      @errors
    end

    def script_exist? script_id
      Script.exists? script_id
    end
end
