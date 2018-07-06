class PermalinksController < ApplicationController
  respond_to :html, :json, :js

  before_action :authorize
  before_action :not_guest, :not_security, only: [:create]
  before_action :set_permalink, only: [:show]
  before_action :set_default_params, only: [:create]
  before_action :set_title

  # GET /permalinks/token
  def show
    @issues = @permalink.issues.page params[:page]
  end

  # POST /permalinks
  def create
    token      = SecureRandom.urlsafe_base64 32
    @permalink = Permalink.new permalink_params.merge(token: token)

    @permalink.save
    respond_with @permalink
  end

  private

    def set_permalink
      @permalink = Permalink.find_by! token: params[:id]
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
