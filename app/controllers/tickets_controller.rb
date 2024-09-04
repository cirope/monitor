# frozen_string_literal: true

class TicketsController < ApplicationController
  append_view_path 'app/views/issues'

  include Authentication
  include Authorization
  include Issues::Filters
  include Issues::Owner

  before_action :set_title, only: [:index]
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def index
    @tickets = Ticket.tickets.ordered.page params[:page]
    @tickets = @tickets.filter_by filter_params.except(:user)
  end

  def show
    @comment = @ticket.comments.new

    render template: 'show', locals: { issue: @ticket }
  end

  def new
    @ticket = Ticket.new

    render template: 'new', locals: { issue: @ticket }
  end

  def edit
    render template: 'edit', locals: { issue: @ticket }
  end

  def create
    @ticket       = Ticket.new ticket_params
    @ticket.owner = @owner if @owner

    if @ticket.save
      redirect_to [@owner, @ticket, context: @context, filter: ticket_filter]
    else
      render template: 'new', status: :unprocessable_entity, locals: { issue: @ticket }
    end
  end

  def update
    if @ticket.update ticket_params
      redirect_to [@owner, @ticket, context: @context, filter: ticket_filter]
    else
      render template: 'edit', status: :unprocessable_entity, locals: { issue: @ticket }
    end
  end

  def destroy
    owner = @ticket.owner

    @ticket.nullify

    redirect_to owner
  end

  private

    def set_ticket
      @ticket = Ticket.find_by id: params[:id]
    end

    def ticket_filter
      params[:filter]&.to_unsafe_h
    end

    def ticket_params
      params.require(:ticket).permit :status, :title, :description,
        :owner_type, :lock_version,
        subscriptions_attributes: [:id, :user_id, :_destroy],
        comments_attributes:      [:id, :text, :attachment],
        taggings_attributes:      [:id, :tag_id, :_destroy]
    end
end
