module EndpointsHelper
  def endpoint_providers
    Endpoint.providers.keys.map do |provider|
      [ Endpoint.i18n_provider(provider), provider ]
    end
  end
end
