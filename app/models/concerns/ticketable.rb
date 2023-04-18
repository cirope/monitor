module Ticketable
  extend ActiveSupport::Concern

  included do
    has_many :tickets, as: :owner, class_name: 'Issue', dependent: :destroy
  end

  def pending_ticket
    ticket = tickets.take

    ticket if tickets.one? && ticket&.pending?
  end
end
