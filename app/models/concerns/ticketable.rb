module Ticketable
  extend ActiveSupport::Concern

  included do
    after_destroy :nullify_tickets

    has_many :tickets, as: :owner, class_name: 'Issue', dependent: :destroy
  end

  private

    def nullify_tickets
      tickets.update_all owner_id: nil
    end
end
