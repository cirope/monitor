# frozen_string_literal: true

class Tickets::CommentsController < ApplicationController

  include Authentication
  include Authorization
  include Issues::Filters
  include Issues::Owner

  before_action :set_ticket
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
    render 'issues/comments/show', locals: set_locals
  end

  def edit
    render 'issues/comments/edit', locals: set_locals
  end

  def create
    @comment = current_user.comments.new comment_params.merge issue_id: @ticket.id

    if @comment.save
      redirect_to [@owner, @ticket]
    else
      render template: 'tickets/show', status: :unprocessable_entity
    end
  end

  def update
    @comment.update comment_params

    render 'issues/comments/update', locals: set_locals
  end

  def destroy
    @comment.destroy

    render 'issues/comments/destroy', locals: set_locals
  end

  private

    def set_ticket
      @ticket = Ticket.find_by id: params[:ticket_id]
    end

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def set_locals
      { issue: @ticket }
    end

    def comment_params
      params.require(:comment).permit :text, :attachment
    end
end
