class UsersController < ApplicationController
  include Users::Filters

  before_action :authorize, :not_guest
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]
  before_action :not_author, only: [:edit, :update, :destroy]

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

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: t('flash.actions.create.notice', resource_name: User.model_name.human) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if update_resource @user, user_params
        format.html { redirect_to @user, notice: t('flash.actions.update.notice', resource_name: User.model_name.human) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_url, notice: t('flash.actions.destroy.notice', resource_name: User.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to users_url, alert: t('flash.actions.destroy.alert', resource_name: User.model_name.human) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_user
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit :name, :lastname, :email, :username, :password, :password_confirmation, :role, :lock_version,
        taggings_attributes: [:id, :tag_id, :_destroy]
    end
end
