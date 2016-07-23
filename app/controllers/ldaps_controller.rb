class LdapsController < ApplicationController
  before_action :authorize, :not_guest, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_ldap, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

  def index
    @ldaps = Ldap.order(:id).page params[:page]
  end

  def show
  end

  def new
    @ldap = Ldap.new
  end

  def edit
  end

  def create
    @ldap = Ldap.new ldap_params

    respond_to do |format|
      if @ldap.save
        format.html { redirect_to @ldap, notice: t('flash.actions.create.notice', resource_name: Ldap.model_name.human) }
        format.json { render :show, status: :created, location: @ldap }
      else
        format.html { render :new }
        format.json { render json: @ldap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ldaps/1
  def update
    respond_to do |format|
      if update_resource @ldap, ldap_params
        format.html { redirect_to @ldap, notice: t('flash.actions.update.notice', resource_name: Ldap.model_name.human) }
        format.json { render :show, status: :ok, location: @ldap }
      else
        format.html { render :edit }
        format.json { render json: @ldap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ldaps/1
  def destroy
    respond_to do |format|
      if @ldap.destroy
        format.html { redirect_to ldaps_url, notice: t('flash.actions.destroy.notice', resource_name: Ldap.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to ldaps_url, alert: t('flash.actions.destroy.alert', resource_name: Ldap.model_name.human) }
        format.json { render json: @ldap.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_ldap
      @ldap = Ldap.find params[:id]
    end

    def ldap_params
      params.require(:ldap).permit :hostname, :port, :basedn, :filter,
        :login_mask, :username_attribute, :name_attribute,
        :lastname_attribute, :email_attribute, :roles_attribute,
        :test_user, :test_password,
        :role_guest, :role_author, :role_supervisor, :role_security,
        :lock_version
    end
end
