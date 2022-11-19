# frozen_string_literal: true

class LdapsController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_author
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

    if @ldap.save
      redirect_to @ldap
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @ldap.update ldap_params
      redirect_to @ldap
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @ldap.destroy

    redirect_to ldaps_url
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
