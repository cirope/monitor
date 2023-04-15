# frozen_string_literal: true

class TicketsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters

  before_action :set_title, :set_owner, only: [:index]
  before_action :set_ticket, only: [:destroy]

  def index
    @issues = (@owner || Issue).tickets.ordered.page params[:page]
  end

  def destroy
    owner = @ticket.owner

    @ticket.nullify

    redirect_to owner
  end

  private

    def set_ticket
      @ticket = Issue.find_by id: params[:id]
    end
end
