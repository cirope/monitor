# frozen_string_literal: true

class PanelsController < ApplicationController
  respond_to :js

  before_action :authorize
  before_action :set_dashboard, only: [:new, :create]
  before_action :set_panel, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /panels/1
  def show
    respond_with @panel if @panel
  end

  # GET /dashboards/1/panels/new
  def new
    @panel = @dashboard.panels.new

    respond_with @panel
  end

  # GET /panels/1/edit
  def edit
    respond_with @panel
  end

  # POST /dashboards/1/panels
  def create
    @panel = @dashboard.panels.new panel_params

    @panel.save
    respond_with @panel
  end

  # PATCH/PUT /panels/1
  def update
    update_resource @panel, panel_params

    respond_with @panel
  end

  # DELETE /panels/1
  def destroy
    @panel.destroy

    respond_with @panel
  end

  private

    def set_dashboard
      @dashboard = current_user.dashboards.find params[:dashboard_id]
    end

    def set_panel
      @panel = current_user.panels.find params[:id] unless params[:id] == 'nil'
    end

    def panel_params
      params.require(:panel).permit :title, :height, :width, :lock_version
    end
end
