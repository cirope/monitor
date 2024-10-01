module Tickets::Scoped
  extend ActiveSupport::Concern

  included do
    before_action :set_ticket
  end

  private

    def set_ticket
      @ticket = Ticket.find_by id: params[:ticket_id]
    end
end
