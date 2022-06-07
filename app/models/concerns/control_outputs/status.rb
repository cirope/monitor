module ControlOutputs::Status
  extend ActiveSupport::Concern

  included do
    scope :executed, -> { by_status %w(ok error) }

    enum status: {
      running:   'running',
      ok:        'ok',
      error:     'error'
    }

    before_validation :initial_status
  end

  module ClassMethods
    def by_status status
      where status: status
    end

    def success_status
      statuses[:ok]
    end
  end

  private

    def initial_status
      self.status ||= 'running'
    end
end
