class LdapsController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title, except: [:destroy]
  before_action :set_ldap, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ldaps = Ldap.order(:id).page params[:page]

    respond_with @ldaps
  end

  def show
    respond_with @ldap
  end

  def new
    @ldap = Ldap.new

    respond_with @ldap
  end

  def edit
  end

  def create
    @ldap = Ldap.new ldap_params

    @ldap.save
    respond_with @ldap
  end

  def update
    @ldap.update ldap_params

    respond_with @ldap
  end

  def destroy
    @ldap.destroy

    respond_with @ldap
  end

  private

    def set_ldap
      @ldap = Ldap.find params[:id]
    end

    def ldap_params
      params.require(:ldap).permit :hostname, :port, :basedn, :filter,
        :login_mask, :username_attribute, :name_attribute,
        :lastname_attribute, :email_attribute, :test_user, :test_password,
        :role_guest, :role_author, :role_supervisor, :role_security,
        :lock_version
    end
end
