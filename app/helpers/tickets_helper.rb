module TicketsHelper
  def ticket_types
    Ticket.ticket_types.map { |tt| [tt.constantize.model_name.human(count: 1), tt] }
  end
end
