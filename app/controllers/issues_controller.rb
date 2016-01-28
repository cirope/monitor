class IssuesController < ApplicationController
  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:index]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  helper_method :filter_params

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
    respond_with @issue, location: script_issues_url(@issue.script)
  end

  private

    def set_issue
      @issue = issues.find params[:id]
    end

    def set_script
      @script = Script.find params[:script_id] if params[:script_id]
    end

    def issue_params
      args = current_user.guest? ? guest_permitted : others_permitted

      params.require(:issue).permit(*args)
    end

    def filter_params
      params[:filter].present? ?
        params.require(:filter).permit(:description, :status, :tags) :
        {}
    end

    def others_permitted
      [
        :status, :description,
          subscriptions_attributes: [:id, :user_id, :_destroy],
          comments_attributes: [:id, :text, :file, :file_cache],
          taggings_attributes: [:id, :tag_id, :_destroy]
      ]
    end

    def guest_permitted
      [
        comments_attributes: [:id, :text, :file, :file_cache]
      ]
    end

    def issues
      issues = if current_user.guest?
        current_user.issues
      else
        @script ? Issue.script_scoped(@script) : Issue.all
      end

      issues = issues.active if filter_params[:status].blank?

      issues.filter(filter_params)
    end
end
