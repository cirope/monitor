# frozen_string_literal: true

class Rules::VersionsController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_title, :set_owner
  before_action :set_version, only: [:show]

  def index
    @versions = @owner.versions_with_text_changes.reorder(
      created_at: :desc
    ).page params[:page]

    render 'versions/index'
  end

  def show
    render 'versions/show'
  end

  private

    def set_version
      @version = @owner.trigger_versions.find params[:id]
    end

    def set_owner
      @owner = Rule.find params[:rule_id]
    end
end
