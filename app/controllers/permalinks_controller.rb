class PermalinksController < ApplicationController
  before_action :authorize
  before_action :not_guest, :not_security, only: [:create]
  before_action :set_permalink, only: [:show]
  before_action :set_title

  # GET /permalinks/token
  def show
    @issues = @permalink.issues.page params[:page]
  end

  # POST /permalinks
  def create
    token      = SecureRandom.urlsafe_base64 32
    @permalink = Permalink.new permalink_params.merge(token: token)

    respond_to do |format|
      if @permalink.save
        format.html { redirect_to @permalink, notice: t('flash.actions.create.notice', resource_name: Permalink.model_name.human) }
        format.json { render :show, status: :created, location: @permalink }
        format.js
      end
    end
  end

  private

    def set_permalink
      @permalink = Permalink.find_by! token: params[:id]
    end

    def permalink_params
      params.require(:permalink).permit :token, issue_ids: []
    end
end
