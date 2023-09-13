# frozen_string_literal: true

class DrivesController < ApplicationController
  include Authentication
  include Authorization

  content_security_policy false

  before_action :set_title, except: [:destroy]
  before_action :set_account
  before_action :set_drive, only: [:show, :edit, :update, :destroy]

  # GET /drives
  def index
    @drives = @account.drives.ordered.page params[:page]
  end

  # GET /drives/1
  def show
  end

  # GET /drives/new
  def new
    @drive = @account.drives.new
  end

  # GET /drives/1/edit
  def edit
  end

  # POST /drives
  def create
    @drive = @account.drives.new drive_params

    if @drive.save
      redirect_to provider_auth_url(@drive), allow_other_host: true
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drives/1
  def update
    if @drive.update drive_params
      if @drive.redirect_to_auth_url?
        redirect_to provider_auth_url(@drive), allow_other_host: true
      else
        redirect_to @drive
      end
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /drives/1
  def destroy
    @drive.destroy

    redirect_to drives_url
  end

  private

    def set_account
      @account = Current.account
    end

    def set_drive
      @drive = @account.drives.find params[:id]
    end

    def drive_params
      params.require(:drive).permit :name, :provider, :client_id,
        :client_secret, :root_folder_id, :tenant_id, :drive_id
    end
end
