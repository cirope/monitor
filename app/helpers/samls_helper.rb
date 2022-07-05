module SamlsHelper
  def providers
    Saml::PROVIDERS.map { |p| [t("samls.providers.#{p}"), p] }
  end
end
