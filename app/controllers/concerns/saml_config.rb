module SamlConfig
  extend ActiveSupport::Concern

  included do
    helper_method :saml
  end

  def saml
    @saml ||= Saml.default
  end
end
