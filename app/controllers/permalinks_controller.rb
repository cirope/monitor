# frozen_string_literal: true

class PermalinksController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_account, only: [:show]
  before_action :set_permalink, only: [:show]
  before_action :set_default_params, only: [:create]
  before_action :set_title

  # GET /permalinks/token
  def show
    @issues = @permalink.issues.page params[:page]
  end

  # POST /permalinks
  def create
    @permalink = Permalink.create permalink_params
  end

  private

    def set_permalink
      @permalink = Permalink.find_by! token: params[:id]
    end

    def set_account
      if params[:account_id]
        account = Account.find_by! tenant_name: params[:account_id]

        account.switch { set_permalink }

        session[:tenant_name] = account.tenant_name

        redirect_to permalink_url(@permalink)
      end
    end

    def permalink_params
      params.require(:permalink).permit issue_ids: []
    end

    def set_default_params
      params[:permalink] ||= { issue_ids: board_issues }
    end

    def board_issues
      session[:board_issues] ||= []
    end
end
