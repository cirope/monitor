# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :authorize
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /roles
  def index
    @roles = Role.ordered.page params[:page]
  end

  # GET /roles/1
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  def create
    @role = Role.new role_params

    if @role.save
      redirect_to @role
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1
  def update
    if @role.update role_params
      redirect_to @role
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy

    redirect_to roles_url
  end

  private

    def set_role
      @role = Role.find params[:id]
    end

    def role_params
      params.require(:role).permit :name, :description, :type, :lock_version,
        permissions_attributes: [
          :id, :section, :read, :edit, :remove, :_destroy
        ]
    end
end
