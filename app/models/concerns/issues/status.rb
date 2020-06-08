# frozen_string_literal: true

module Issues::Status
  extend ActiveSupport::Concern

  STATUSES = %w(pending taken closed)

  STATUS_TRANSITIONS = {
    pending: %w(pending taken closed),
    taken:   %w(taken closed),
    closed:  %w(closed)
  }.freeze

  SUPERVISOR_STATUS_TRANSITIONS = STATUS_TRANSITIONS.merge(
    closed: %w(taken closed)
  ).freeze

  included do
    before_validation :set_default_status
  end

  module ClassMethods
    def statuses
      STATUSES
    end
  end

  def next_status
    if PaperTrail.request.whodunnit
      user = User.find_by id: PaperTrail.request.whodunnit
    end

    transitions = if user&.supervisor?
                    SUPERVISOR_STATUS_TRANSITIONS
                  else
                    STATUS_TRANSITIONS
                  end

    transitions[(status_was || status).to_sym] || []
  end

  STATUSES.each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  private

    def set_default_status
      self.status ||= 'pending'
    end
end
