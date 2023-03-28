# frozen_string_literal: true

class SamlsController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_saml, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  # GET /samls
  def index
    @samls = Saml.order(:id).page params[:page]
  end

  # GET /samls/1
  def show
  end

  # GET /samls/new
  def new
    @saml = Saml.new
  end

  # GET /samls/1/edit
  def edit
  end

  # POST /samls
  def create
    @saml = Saml.new saml_params

    if @saml.save
      redirect_to @saml
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /samls/1
  def update
    if @saml.update saml_params
      redirect_to @saml
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /samls/1
  def destroy
    @saml.destroy

    redirect_to samls_url
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
        :roles_attribute, :lock_version
    end
end
