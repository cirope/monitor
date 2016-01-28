class Issues::BoardController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title
  before_action :set_issue, only: [:create, :destroy]

  respond_to :html, :js

  def index
    @issues = issues.order(:created_at).where(id: board_session).page params[:page]

    respond_with @issues
  end

  def create
    board_session << @issue.id

    respond_with @issue
  end

  def destroy
    board_session.delete @issue.id

    respond_with @issue
  end

  private

    def set_issue
      @issue = issues.find params[:issue_id]
    end

    def issues
      current_user.guest? ? current_user.issues : Issue.all
    end

    def board_session
      session[:board_issues] ||= []
    end
end
