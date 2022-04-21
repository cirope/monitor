# frozen_string_literal: true

class DashboardsController < ApplicationController
  respond_to :html

  before_action :authorize
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /dashboards
  def index
    @dashboards = current_user.dashboards.order(:name).page params[:page]

    respond_with @dashboards
  end

  # GET /dashboards/1
  def show
    respond_with @dashboard
  end

  # GET /dashboards/new
  def new
    @dashboard = current_user.dashboards.new

    respond_with @dashboard
  end

  # GET /dashboards/1/edit
  def edit
    respond_with @dashboard
  end

  # POST /dashboards
  def create
    @dashboard = current_user.dashboards.new dashboard_params

    @dashboard.save
    respond_with @dashboard
  end

  # PATCH/PUT /dashboards/1
  def update
    update_resource @dashboard, dashboard_params

    respond_with @dashboard
  end

  # DELETE /dashboards/1
  def destroy
    @dashboard.destroy

    respond_with @dashboard
  end

  private

    def set_dashboard
      @dashboard = current_user.dashboards.find params[:id]
    end

    def dashboard_params
      params.require(:dashboard).permit :name, :lock_version
    end
end
