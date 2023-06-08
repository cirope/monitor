module DrivesHelper
  def drive_providers
    Drive::PROVIDERS.map do |provider|
      [
        i18n_provider(provider),
        provider,
        data: {
          drive_provider_options_url: drives_provider_options_url(provider: provider)
        }
      ]
    end
  end

  def i18n_provider provider
    t "drives.providers.#{provider}"
  end
end
