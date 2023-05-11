module Tickets::Scoped
  extend ActiveSupport::Concern

  included do
    before_action :set_ticket
  end

  private

    def set_ticket
      @ticket = Issue.find_by id: params[:issue_id]
    end
end
