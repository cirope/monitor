module Issues::Status
  extend ActiveSupport::Concern

  def next_status
    {
      pending: %w(pending taken closed),
      taken:   %w(taken closed),
      closed:  %w(closed)
    }[status.to_sym] || []
  end
end
