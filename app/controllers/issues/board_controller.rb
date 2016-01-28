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

  def update
    _issues = issues.where id: board_session

    update_issues _issues

    if board_session_errors.empty?
      redirect_to issues_board_url, notice: t('.updated')
    else
      redirect_to issues_board_url, alert: t('.fail')
    end
  end

  def destroy
    board_session.delete @issue.id

    respond_with @issue, location: issues_board_url
  end

  def empty
    board_session.clear
    board_session_errors.clear

    redirect_to dashboard_url, notice: t('.done')
  end

  private

    def set_issue
      @issue = issues.find params[:issue_id]
    end

    def issue_params
      params.require(:issue).permit :description, :status
    end

    def issues
      current_user.guest? ? current_user.issues : Issue.all
    end

    def board_session
      session[:board_issues] ||= []
    end

    def board_session_errors
      session[:board_issue_errors] ||= {}
    end

    def update_issues issues
      _issue_params = issue_params.select { |_, value| value.present? }

      board_session_errors.clear

      issues.find_each do |issue|
        updated = issue.update _issue_params
        board_session_errors[issue.id] = issue.errors.full_messages unless updated
      end
    end
end
