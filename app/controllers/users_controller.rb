# frozen_string_literal: true

class UsersController < ApplicationController
  include Authentication
  include Authorization
  include Users::Filters

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /users
  def index
    @users = users.visible.ordered.page params[:page]
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new user_params

    if @user.restore?
      find_user_and_restore
    elsif @user.save
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update user_params
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.hide

    redirect_to users_url
  end

  private

    def set_user
      @user = User.find params[:id]
    end

    def find_user_and_restore
      @user = @user.find_and_restore!

      if @user.persisted?
        redirect_to @user
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def user_params
      params.require(:user).permit :name, :lastname, :email, :username, :password, :password_confirmation,
        :role_id, :restore, :lock_version, taggings_attributes: [:id, :tag_id, :_destroy]
    end
end
