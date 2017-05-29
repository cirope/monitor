class TaggingsController < ApplicationController
  respond_to :js, :json

  before_action :authorize, :set_issue
  before_action :set_tagging, only: [:show, :destroy]
  before_action :set_title, except: [:destroy]

  def new
    @tagging = @issue.taggings.new

    respond_with @tagging
  end

  def create
    @tagging = @new_tagging = @issue.taggings.new tagging_params
    @tagging = current_user.taggings.new if @tagging.save

    respond_with @tagging
  end

  def destroy
    @tagging.destroy
    respond_with @tagging
  end

  private

    def set_issue
      @issue = issues.find params[:issue_id]
    end

    def set_tagging
      @tagging = @issue.taggings.find params[:id]
    end

    def tagging_params
      params.require(:tagging).permit :tag_id
    end

    def issues
      current_user.supervisor? ? Issue.all : current_user.issues
    end
end
