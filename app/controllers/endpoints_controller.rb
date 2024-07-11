# frozen_string_literal: true

class EndpointsController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_title, except: [:destroy]
  before_action :set_endpoint, only: [:show, :edit, :update, :destroy]

  # GET /endpoints
  def index
    @endpoints = Endpoint.ordered.page params[:page]
  end

  # GET /endpoints/1
  def show
  end

  # GET /endpoints/new
  def new
    @endpoint = Endpoint.new
  end

  # GET /endpoints/1/edit
  def edit
  end

  # POST /endpoints
  def create
    @endpoint = Endpoint.new endpoint_params

    if @endpoint.save
      redirect_to @endpoint
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /endpoints/1
  def update
    if @endpoint.update endpoint_params
      redirect_to @endpoint
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /endpoints/1
  def destroy
    @endpoint.destroy

    redirect_to endpoints_url
  end

  private

    def set_endpoint
      @endpoint = Endpoint.find params[:id]
    end

    def endpoint_params
      allowed_params = [:name, :provider, :lock_version] << @endpoint.required_options

      params.require(:endpoint).permit *allowed_params
    end
end
