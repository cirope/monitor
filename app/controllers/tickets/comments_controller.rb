# frozen_string_literal: true

class Tickets::CommentsController < Issues::CommentsController

  before_action :set_issue
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def create
    @comment = current_user.comments.new comment_params.merge issue_id: @issue.id

    if @comment.save
      redirect_to [@owner, @comment.issue]
    else
      render template: 'tickets/show', status: :unprocessable_entity
    end
  end

  private

  def set_issue
    @issue = Ticket.find_by id: params[:ticket_id]
  end
end
