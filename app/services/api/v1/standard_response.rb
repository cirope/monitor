# frozen_string_literal: true

class Api::V1::StandardResponse
  def call data:, code:
    {
      data: data,
      code: code
    }
  end
end
