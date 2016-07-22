class IssuesController < ApplicationController
  include Issues::Filters

  before_action :authorize
  before_action :not_guest, :not_security, except: [:index, :show, :edit, :update]
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:index]
  before_action :set_permalink, only: [:show]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @issue_ids = issues.pluck 'id'
    @issues    = issues.order(created_at: :desc).page params[:page]
    @issues    = @issues.active unless filter_default_status?

    respond_with @issues
  end

  def show
    respond_with @issue
  end

  def edit
    respond_with @issue
  end

  def update
    @issue.update issue_params
    respond_with @issue
  end

  def destroy
    @issue.destroy
    respond_with @issue, location: script_issues_url(@issue.script, filter: params[:filter])
  end

  private

    def set_issue
      @issue = issues.find params[:id]
    end

    def set_script
      @script = Script.find params[:script_id] if params[:script_id]
    end

    def set_permalink
      @permalink = Permalink.find_by! token: params[:permalink_id] if params[:permalink_id]
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
end
