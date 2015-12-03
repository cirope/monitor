class IssuesController < ApplicationController
  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @issues = issues.order(created_at: :desc).page params[:page]

    respond_with @issues
  end

  def show
    respond_with @issue
  end

  def edit
  end

  def update
    @issue.update issue_params
    respond_with @issue
  end

  def destroy
    @issue.destroy
    respond_with @issue
  end

  private
    def set_issue
      @issue = issues.find params[:id]
    end

    def issue_params
      params.require(:issue).permit :status, :description,
        subscriptions_attributes: [:id, :user_id, :_destroy],
        comments_attributes: [:id, :text, :file, :file_cache]
    end

    def issues
      current_user.guest? ? current_user.issues : Issue.all
    end
end
