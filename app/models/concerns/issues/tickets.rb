module Issues::Tickets
  extend ActiveSupport::Concern

  def ticket?
    owner_type != 'Run'
  end
end
