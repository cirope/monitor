module Issues::Status
  extend ActiveSupport::Concern

  included do
    before_validation :set_default_status
  end

  def next_status
    {
      pending: %w(pending taken closed),
      taken:   %w(taken closed),
      closed:  %w(closed)
    }[status.to_sym] || []
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
