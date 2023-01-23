# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authorize
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /dashboards
  def index
    @dashboards = current_user.dashboards.order(:name).page params[:page]
  end

  # GET /dashboards/1
  def show
  end

  # GET /dashboards/new
  def new
    @dashboard = current_user.dashboards.new
  end

  # GET /dashboards/1/edit
  def edit
  end

  # POST /dashboards
  def create
    @dashboard = current_user.dashboards.new dashboard_params

    if @dashboard.save
      redirect_to @dashboard
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dashboards/1
  def update
    if @dashboard.update dashboard_params
      redirect_to @dashboard
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /dashboards/1
  def destroy
    @dashboard.destroy

    redirect_to dashboards_url
  end

  private

    def set_dashboard
      @dashboard = current_user.dashboards.find params[:id]
    end

    def dashboard_params
      params.require(:dashboard).permit :name, :lock_version
    end
end
