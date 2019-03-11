# frozen_string_literal: true

class LdapsController < ApplicationController
  before_action :authorize, :not_guest, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_ldap, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

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
    respond_with @ldap
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
        :lastname_attribute, :email_attribute, :roles_attribute,
        :test_user, :test_password,
        :role_guest, :role_author, :role_supervisor, :role_security,
        :lock_version
    end
end
