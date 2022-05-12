# frozen_string_literal: true

module Issues::Status
  extend ActiveSupport::Concern

  STATUSES = %w(pending taken revision closed)

  STATUS_TRANSITIONS = {
    pending:  %w(pending taken revision closed),
    taken:    %w(taken revision closed),
    revision: %w(revision closed),
    closed:   %w(closed)
  }.freeze

  MANAGER_STATUS_TRANSITIONS = STATUS_TRANSITIONS.merge(
    pending: %w(pending taken)
  ).freeze

  OWNER_STATUS_TRANSITIONS = {
    pending:  %w(pending taken revision),
    taken:    %w(taken revision),
    revision: %w(revision)
  }.freeze

  SUPERVISOR_STATUS_TRANSITIONS = STATUS_TRANSITIONS.merge(
    closed: %w(taken revision closed)
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
    transitions = if Current.user&.supervisor?
                    SUPERVISOR_STATUS_TRANSITIONS
                  elsif Current.user&.owner?
                    OWNER_STATUS_TRANSITIONS
                  elsif Current.user&.manager?
                    MANAGER_STATUS_TRANSITIONS
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
