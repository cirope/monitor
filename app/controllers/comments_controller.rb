class CommentsController < ApplicationController
  respond_to :js

  before_action :authorize
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def show
    respond_with @comment
  end

  def edit
    respond_with @comment
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
      params.require(:comment).permit :text
    end
end
