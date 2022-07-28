module Samls::Response
  extend ActiveSupport::Concern

  def process_response response
    saml_config   = OneLogin::RubySaml::Settings.new settings
    saml_response = OneLogin::RubySaml::Response.new response, settings: saml_config

    if saml_response.is_valid?
      saml_user_for saml_response.nameid, saml_response.attributes
    end
  end

  private

    def saml_user_for email, attributes
      result = nil
      pruned_attributes = prune_custom_attributes attributes
      pruned_attributes[:email] ||= email

      if user = find_user(pruned_attributes)
        role = extract_role pruned_attributes

        if role
          update_user user, role, pruned_attributes

          return user, 'valid'
        else
          return user, 'not_authorized'
        end
      end
    end

    def find_user attributes
      User.find_by(email: attributes[:email]&.downcase) ||
        User.find_by(username: attributes[:username]&.downcase)
    end

    def update_user user, role, attributes
      User.transaction do
        user.update(
          username: attributes[:username],
          name:     attributes[:name],
          lastname: attributes[:lastname],
          email:    attributes[:email],
          role:     role,
          hidden:   false
        )
      end
    end

    def extract_role attributes
      role_names = attributes[:roles]

      User::ROLES.detect do |role|
        role_name = send "role_#{role}"

        role_names.include? role_name
      end
    end

    def prune_custom_attributes attributes
      {
        username: Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{username_attribute}"]).first.to_s.sub(/@.+/, ''),
        name:     Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{name_attribute}"]).first,
        lastname: Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{lastname_attribute}"]).first,
        email:    Array(attributes["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/#{email_attribute}"]).first,
        roles:    Array(attributes["http://schemas.microsoft.com/ws/2008/06/identity/claims/#{roles_attribute}"])
      }
    end
end
