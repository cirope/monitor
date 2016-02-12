class Issues::BoardController < ApplicationController
  include Issues::Filters

  before_action :authorize, :not_guest
  before_action :set_title
  before_action :set_issue,  only: [:create, :destroy]
  before_action :set_script, only: [:create, :destroy]

  respond_to :html, :js

  def index
    @issue_ids = issues.where(id: board_session).pluck 'id'
    @issues = issues.order(:created_at).where(id: board_session).page params[:page]

    respond_with @issues
  end

  def create
    @issues = filter_default_status? || @issue ? issues : issues.active

    board_session.concat(@issues.pluck('id')).uniq!

    redirect_to :back unless request.xhr?
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
    @issues = filter_default_status? || @issue ? issues : issues.active

    @issues.each { |issue| board_session.delete issue.id }

    redirect_to :back unless request.xhr?
  end

  def empty
    board_session.clear
    board_session_errors.clear

    redirect_to dashboard_url, notice: t('.done')
  end

  private

    def set_issue
      @issue = issues.find filter_params[:id] if filter_params[:id]
    end

    def set_script
      @script = Script.find params[:script_id] if params[:script_id]
    end

    def issue_params
      params.require(:issue).permit :description, :status
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
        unless issue.update _issue_params
          board_session_errors[issue.id] = issue.errors.full_messages
        end
      end
    end
end
