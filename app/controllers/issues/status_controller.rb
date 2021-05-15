# frozen_string_literal: true

class Issues::StatusController < ApplicationController
  include Issues::Filters

  respond_to :js

  before_action :authorize, :only_owner, :set_issue

  def update
    @issue.update issue_params

    respond_with @issue
  end

  private

    def issue_params
      params.require(:issue).permit :status
    end

    def set_issue
      @issue = issues.find params[:id]
    end
end
