class MembershipsController < ApplicationController
  respond_to :html

  before_action :authorize
  before_action :set_membership, only: [:show, :update]
  before_action :set_title, except: [:destroy]

  # GET /memberships
  def index
    @memberships = current_user.memberships.includes(:account).page params[:page]
  end

  # GET /memberships/1
  def show
    respond_with @membership
  end

  # PATCH/PUT /memberships/1
  def update
    update_resource @membership, membership_params

    respond_with @membership
  end

  private

    def set_membership
      @membership = current_user.memberships.find params[:id]
    end

    def membership_params
      params.require(:membership).permit :default
    end
end
