class MembershipsController < ApplicationController
  include Memberships::Filters

  respond_to :html, :js

  before_action :authorize
  before_action :set_membership, only: [:show, :update]
  before_action :set_title, except: [:destroy]

  # GET /memberships
  def index
    @memberships = memberships.
      includes(:account).
      order(Arel.sql "#{Account.table_name}.name").
      page params[:page]
  end

  # GET /memberships/1
  def show
    respond_with @membership
  end

  # PATCH/PUT /memberships/1
  def update
    @default_membership = current_user.default_membership
    update              = @default_membership != @membership

    Membership.transaction do
      if update && @membership.update(default: true)
        @default_membership.update! default: false
      end
    end
  end

  private

    def set_membership
      @membership = current_user.memberships.find params[:id]
    end
end
