# frozen_string_literal: true

module Runs::Status
  extend ActiveSupport::Concern

  def ok?
    status == 'ok'
  end

  def canceled?
    status == 'canceled'
  end

  def error?
    status == 'error'
  end
end
