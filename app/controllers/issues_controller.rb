class IssuesController < ApplicationController
  include Issues::Filters

  before_action :authorize
  before_action :not_guest, :not_security, except: [:index, :show, :edit, :update]
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:index]
  before_action :set_permalink, only: [:show]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  def index
    @issue_ids = issues.pluck 'id'
    @issues    = issues.order(created_at: :desc).page params[:page]
    @issues    = @issues.active unless filter_default_status?
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if update_resource @issue, issue_params
        format.html { redirect_to @issue, notice: t('flash.actions.update.notice', resource_name: Issue.model_name.human) }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      url = script_issues_url @issue.script, filter: params[:filter]

      if @issue.destroy
        format.html { redirect_to url, notice: t('flash.actions.destroy.notice', resource_name: Issue.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to url, alert: t('flash.actions.destroy.alert', resource_name: Issue.model_name.human) }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
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
