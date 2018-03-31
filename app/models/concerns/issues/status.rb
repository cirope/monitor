module Issues::Status
  extend ActiveSupport::Concern

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

  def next_status
    if PaperTrail.request.whodunnit
      user = User.find PaperTrail.request.whodunnit
    end

    transitions = if user&.supervisor?
                    SUPERVISOR_STATUS_TRANSITIONS
                  else
                    STATUS_TRANSITIONS
                  end

    transitions[(status_was || status).to_sym] || []
  end

  %w(pending taken closed).each do |status|
    define_method "#{status}?" do
      self.status == status
    end
  end

  private

    def set_default_status
      self.status ||= 'pending'
    end
end
