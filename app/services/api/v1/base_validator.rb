# frozen_string_literal: true

class Api::V1::BaseValidator
  def initialize(params)
    @params = params
  end

  def valid?
    validate
    @errors.empty?
  end

  def errors
    @errors ||= validate
    return nil if @errors.empty?

    {
      data: @errors,
      code: 404
    }
  end

  private

    def numeric?(num)
      Integer(num) if num.present?
      true
    rescue
      false
    end
end
