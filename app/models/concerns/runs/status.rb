module Runs::Status
  extend ActiveSupport::Concern

  included do
    scope :executed, -> { where status: %w(ok error) }
  end

  def ok?
    status == 'ok'
  end

  def canceled?
    status == 'canceled'
  end
end
