module DrivesHelper
  def drive_providers
    Drive::PROVIDERS.map { |p| [i18n_provider(p), p] }
  end

  def i18n_provider provider
    t "drives.providers.#{provider}"
  end
end
