class SamlSessionsController < ApplicationController
  include Sessions

  skip_before_action :verify_authenticity_token, raise: false

  before_action :set_account
  before_action :set_saml_config, only: [:new, :metadata]

  def new
    if @saml_config
      saml_request = OneLogin::RubySaml::Authrequest.new
      action = saml_request.create @saml_config

      redirect_to action
    else
      redirect_to login_url, alert: t('sessions.create.invalid', scope: :flash)
    end
  end

  def metadata
    meta = OneLogin::RubySaml::Metadata.new

    render xml: meta.generate(@saml_config)
  end

  def create
    if @account
      @account.switch do
        auth = ServiceSaml.new saml, params[:SAMLResponse]

        if auth.authenticated?
          create_login_record   auth.user
          store_auth_token      auth.user
          store_current_account @account

          redirect_to default_url, notice: t('authentications.logged_in', scope: :flash)
        else
          create_fail_record auth.user

          redirect_to login_url, alert: t('sessions.create.invalid', scope: :flash)
        end
      end
    else
      redirect_to login_url, alert: t('sessions.create.invalid', scope: :flash)
    end
  end

  private

    def set_account
      @account = Account.find_by tenant_name: params['tenant_name']
    end

    def set_saml_config
      @saml_config = OneLogin::RubySaml::Settings.new @saml.settings if saml
    end
end
