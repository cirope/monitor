# frozen_string_literal: true

class MembershipsController < ApplicationController
  include Memberships::Filters

  before_action :authorize
  before_action :set_membership, only: [:update]
  before_action :set_title, except: [:destroy]

  # GET /memberships
  def index
    @memberships = memberships.
      includes(:account).
      order(Arel.sql "#{Account.table_name}.name").
      page params[:page]
  end

  # PATCH/PUT /memberships/1
  def update
    @default_membership = current_user.default_membership

    @membership.update! default: true
  end

  private

    def set_membership
      @membership = current_user.memberships.find params[:id]
    end
end
