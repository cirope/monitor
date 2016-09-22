module Runs::Status
  extend ActiveSupport::Concern

  def ok?
    status == 'ok'
  end

  def canceled?
    status == 'canceled'
  end
end
