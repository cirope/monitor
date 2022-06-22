# frozen_string_literal: true

class SamlsController < ApplicationController
  before_action :authorize, :not_guest, :not_owner, :not_manager, :not_author
  before_action :set_saml, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]
  before_action :not_supervisor, except: [:index, :show]

  respond_to :html

  # GET /samls
  def index
    @samls = Saml.order(:id).page params[:page]

    respond_with @samls
  end

  # GET /samls/1
  def show
    respond_with @saml
  end

  # GET /samls/new
  def new
    @saml = Saml.new

    respond_with @saml
  end

  # GET /samls/1/edit
  def edit
    respond_with @saml
  end

  # POST /samls
  def create
    @saml = Saml.new saml_params

    @saml.save
    respond_with @saml
  end

  # PATCH/PUT /samls/1
  def update
    @saml.update saml_params

    respond_with @saml
  end

  # DELETE /samls/1
  def destroy
    @saml.destroy

    respond_with @saml
  end

  private

    def set_saml
      @saml = Saml.find params[:id]
    end

    def saml_params
      params.require(:saml).permit :provider, :idp_homepage, :idp_entity_id,
        :idp_sso_target_url, :sp_entity_id, :assertion_consumer_service_url,
        :name_identifier_format, :assertion_consumer_service_binding, :idp_cert,
        :username_attribute, :name_attribute, :lastname_attribute, :email_attribute,
        :roles_attribute, :role_guest, :role_manager, :role_author, :role_supervisor,
        :role_security, :role_owner, :lock_version
    end
end
