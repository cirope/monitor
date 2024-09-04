# frozen_string_literal: true

class Tickets::CommentsController < ApplicationController
  append_view_path 'app/views/issues/comments'

  include Authentication
  include Authorization
  include Issues::Filters
  include Issues::Owner

  before_action :set_ticket
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
    render template: 'show', locals: { issue: @ticket }
  end

  def edit
    render template: 'edit', locals: { issue: @ticket }
  end

  def create
    @comment = current_user.comments.new comment_params.merge issue: @ticket

    if @comment.save
      redirect_to [@owner, @ticket]
    else
      render 'issues/show', status: :unprocessable_entity, locals: { issue: @ticket }
    end
  end

  def update
    @comment.update comment_params

    render template: 'update', locals: { issue: @ticket }
  end

  def destroy
    @comment.destroy

    render template: 'destroy', locals: { issue: @ticket }
  end

  private

    def comment_params
      params.require(:comment).permit :text, :attachment
    end

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def set_ticket
      @ticket = Ticket.find_by id: params[:ticket_id]
    end
end
