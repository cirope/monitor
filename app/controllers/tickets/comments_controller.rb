# frozen_string_literal: true

class Tickets::CommentsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters
  include Issues::Owner

  before_action :set_issue
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def create
    @comment = current_user.comments.new comment_params.merge issue_id: @issue.id

    if @comment.save
      redirect_to [@owner, @comment.issue]
    else
      render template: 'tickets/show', status: :unprocessable_entity
    end
  end

  def update
    @comment.update comment_params
  end

  def destroy
    @comment.destroy
  end

  private

    def set_issue
      @issue = Ticket.find_by id: params[:ticket_id]
    end

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def comment_params
      params.require(:comment).permit :text, :attachment
    end
end
