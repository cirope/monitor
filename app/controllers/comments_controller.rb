# frozen_string_literal: true

class CommentsController < ApplicationController
  respond_to :js, :html

  before_action :authorize
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
    respond_with @comment
  end

  def edit
    respond_with @comment
  end

  def create
    @comment = current_user.comments.new comment_params

    @comment.save

    respond_with @comment, location: issue_url(@comment.issue)
  end

  def update
    update_resource @comment, comment_params

    respond_with @comment
  end

  def destroy
    @comment.destroy

    respond_with @comment
  end

  private

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def comment_params
      params.require(:comment).permit :text, :issue_id, :attachment
    end
end
