# frozen_string_literal: true

class TicketsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters
  include Issues::Owner

  before_action :set_title, only: [:index]
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  def index
    @issues = (@owner || Ticket).tickets.ordered.page params[:page]
    @issues = @issues.filter_by filter_params.except(:user)
  end

  def show
    @comment = @issue.comments.new
  end

  def new
    @issue = Ticket.new
  end

  def edit
  end

  def create
    @issue       = Ticket.new ticket_params
    @issue.owner = @owner if @owner

    if @issue.save
      redirect_to [@owner, @issue, context: @context, filter: params[:filter]&.to_unsafe_h]
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @issue.update ticket_params
      redirect_to [@owner, @issue, context: @context, filter: params[:filter]&.to_unsafe_h]
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    owner = @issue.owner

    @issue.nullify

    redirect_to owner
  end

  private

    def set_ticket
      @issue = Ticket.find_by id: params[:id]
    end

  def ticket_params
    params.require(:ticket).permit *editors_params
  end

  def editors_params
    [
      :status, :title, :description, :owner_type,
      subscriptions_attributes: [:id, :user_id, :_destroy],
      comments_attributes: [:id, :text, :attachment],
      taggings_attributes: [:id, :tag_id, :_destroy]
    ]
  end
end
