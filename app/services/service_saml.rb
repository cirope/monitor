class ServiceSaml
  attr_accessor :user, :auth

  def initialize saml, response
    @saml     = saml
    @response = response

    set_saml_user
  end

  def authenticated?
    @auth
  end

  private

    def set_saml_user
      if @saml
        provider      = @saml.provider
        saml_config   = OneLogin::RubySaml::Settings.new @saml.settings
        saml_response = OneLogin::RubySaml::Response.new @response, settings: saml_config

        if saml_response.is_valid?
          @auth = saml_user_for saml_response.nameid, saml_response.attributes
        end
      end
    end

    def saml_user_for email, attributes
      pruned_attributes = prune_custom_attributes attributes
      email    = pruned_attributes[:email] || email
      username = pruned_attributes[:username]

      if @user = User.find_by(email: email)
        update_user pruned_attributes
      end
    end

    def update_user attributes
      User.transaction do
        @user.update(
          name:     attributes[:name],
          lastname: attributes[:lastname],
          username: attributes[:username],
        )
      end
    end

    def prune_custom_attributes attributes
      {
        username: Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{@saml.username_attribute}"]).first.to_s.sub(/@.+/, ''),
        name:     Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{@saml.name_attribute}"]).first,
        lastname: Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{@saml.lastname_attribute}"]).first,
        email:    Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{@saml.email_attribute}"]).first,
        roles:    attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{@saml.roles_attribute}"],
      }
    end
end
