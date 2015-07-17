module Runs::Status
  extend ActiveSupport::Concern

  included do
    scope :executed, -> { where.not status: %w(pending scheduled running) }
  end

  def ok?
    status == 'ok'
  end
end
