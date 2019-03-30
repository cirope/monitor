# frozen_string_literal: true

module Runs::Status
  extend ActiveSupport::Concern

  included do
    scope :executed, -> { by_status %w(ok error) }

    enum status: {
      aborted:   'aborted',
      canceled:  'canceled',
      pending:   'pending',
      scheduled: 'scheduled',
      running:   'running',
      killed:    'killed',
      ok:        'ok',
      error:     'error'
    }
  end

  module ClassMethods
    def by_status status
      where status: status
    end
  end
end
