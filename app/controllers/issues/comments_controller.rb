# frozen_string_literal: true

class Issues::CommentsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Owner

  before_action :set_issue
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def create
    @comment = current_user.comments.new comment_params.merge issue: @issue

    if @comment.save
      redirect_to [@owner, @comment.issue]
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

    def set_issue
      @issue = Issue.find_by id: params[:issue_id]
    end

    def set_comment
      @comment = current_user.comments.find params[:id]
    end

    def comment_params
      params.require(:comment).permit :text, :attachment
    end
end
