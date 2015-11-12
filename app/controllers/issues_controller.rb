class IssuesController < ApplicationController
  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @issues = issues.order(:created_at).page params[:page]

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
      @issue = Issue.find params[:id]
    end

    def issue_params
      params.require(:issue).permit :status, :description,
        subscriptions_attributes: [:id, :user_id, :_destroy],
        comments_attributes: [:id, :text]
    end

    def issues
      current_user.guest? ? current_user.issues : Issue.all
    end
end
