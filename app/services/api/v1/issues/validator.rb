# frozen_string_literal: true

class Api::V1::Issues::Validator < Api::V1::BaseValidator
  SCRIPT_REQUIRED = 'El id del script es obligatorio'
  SCRIPT_INCORRECT = 'El id del script debe ser numerico'

  private

  def validate
    @errors = []
    @errors << SCRIPT_REQUIRED unless @params['script_id']
    @errors << SCRIPT_INCORRECT unless numeric? @params['script_id']
    @errors
  end
end
