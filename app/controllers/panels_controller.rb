# frozen_string_literal: true

class PanelsController < ApplicationController
  before_action :authorize
  before_action :set_dashboard
  before_action :set_panel, only: [:edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /dashboards/1/panels/new
  def new
    @panel = @dashboard.panels.new
  end

  # GET /panels/1/edit
  def edit
  end

  # POST /dashboards/1/panels
  def create
    @panel = @dashboard.panels.new panel_params

    if @panel.save
      redirect_to @dashboard
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /panels/1
  def update
    if @panel.update panel_params
      redirect_to @dashboard
    else
      render 'edit', status: :unprocessable_entity
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
      params.require(:panel).permit :title, :height, :width, :lock_version,
        queries_attributes: [
          :id, :function, :output, :period, { filters: [] }, :frequency, :from_count,
          :to_count, :from_period, :to_period, :range, :_destroy
        ]
    end
end
