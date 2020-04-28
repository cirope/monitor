# frozen_string_literal: true

class PanelsController < ApplicationController
  respond_to :html

  before_action :authorize
  before_action :set_dashboard
  before_action :set_panel, only: [:edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

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

    if @panel.save
      redirect_to @dashboard
    else
      render 'new'
    end
  end

  # PATCH/PUT /panels/1
  def update
    if update_resource @panel, panel_params
      redirect_to @dashboard
    else
      render 'edit'
    end
  end

  # DELETE /panels/1
  def destroy
    @panel.destroy

    redirect_to @dashboard
  end

  private

    def set_dashboard
      @dashboard = current_user.dashboards.find params[:dashboard_id]
    end

    def set_panel
      @panel = current_user.panels.find params[:id] unless params[:id] == 'nil'
    end

    def panel_params
      params.require(:panel).permit :title, :height, :width, :output, :lock_version,
        queries_attributes: [
          :id, :function, :period, { filters: [] }, :frequency, :from_count,
          :to_count, :from_period, :to_period, :range, :_destroy
        ]
    end
end
