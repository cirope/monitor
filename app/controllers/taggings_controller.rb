# frozen_string_literal: true

class TaggingsController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_issue
  before_action :set_tagging, only: [:show, :destroy]
  before_action :set_title, except: [:destroy]

  def new
    @tagging = @issue.taggings.new
  end

  def create
    @tagging = @new_tagging = @issue.taggings.new tagging_params
    @tagging = current_user.taggings.new if @tagging.save
  end

  def destroy
    @tagging.destroy
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
      if current_user.supervisor? || current_user.manager?
        Issue.all
      else
        current_user.issues
      end
    end
end
