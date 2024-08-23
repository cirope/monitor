module TicketsHelper
  def issue_types
    Ticket.ticket_types.map { |ot| [ot.constantize.model_name.human(count: 1), ot] }
  end
end
