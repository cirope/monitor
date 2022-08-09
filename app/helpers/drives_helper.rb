module DrivesHelper
  def drive_providers
    Drive::PROVIDERS.map { |p| [t("drives.providers.#{p}"), p] }
  end
end
