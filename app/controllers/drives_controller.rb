# frozen_string_literal: true

class DrivesController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_account
  before_action :set_drive, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

  respond_to :html

  # GET /drives
  def index
    @drives = @account.drives.ordered.page params[:page]

    respond_with @drives
  end

  # GET /drives/1
  def show
    respond_with @drive
  end

  # GET /drives/new
  def new
    @drive = @account.drives.new

    respond_with @drive
  end

  # GET /drives/1/edit
  def edit
    respond_with @drive
  end

  # POST /drives
  def create
    @drive = @account.drives.new drive_params

    if @drive.save
      redirect_to @drive.provider_auth_url, allow_other_host: true
    else
      render 'new'
    end
  end

  # PATCH/PUT /drives/1
  def update
    if @drive.update drive_params.except :name
      if @drive.redirect_to_auth_url?
        redirect_to @drive.provider_auth_url, allow_other_host: true
      else
        redirect_to @drive
      end
    else
      render 'edit'
    end
  end

  # DELETE /drives/1
  def destroy
    @drive.destroy

    respond_with @drive
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
        :client_secret, :root_folder_id
    end
end
