# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authorize
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def create
    @comment = current_user.comments.new comment_params

    if @comment.save
      redirect_to issue_url(@comment.issue)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @comment.update comment_params
  end

  def destroy
    @comment.destroy
  end

  private

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def comment_params
      params.require(:comment).permit :text, :issue_id, :attachment
    end
end
