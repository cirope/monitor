module Drives::Options
  extend ActiveSupport::Concern

  PROVIDER_OPTIONS = {
    drive:      { root_folder_id: :string },
    onedrive:   { tenant_id: :string, drive_id: :string },
    sharepoint: { drive_id: :string }
  }

  def provider_options
    if provider.present?
      PROVIDER_OPTIONS[provider.to_sym]
    else
      Array.new
    end
  end

  module ClassMethods
    def provider_options provider
      PROVIDER_OPTIONS[provider.to_sym]
    end
  end

  def root_folder_id
    options&.fetch 'root_folder_id', nil
  end
  alias_method :root_folder_id?, :root_folder_id

  def root_folder_id= root_folder_id
    assign_option 'root_folder_id', root_folder_id
  end

  def tenant_id
    options&.fetch 'tenant_id', nil
  end
  alias_method :tenant_id?, :tenant_id

  def tenant_id= tenant_id
    assign_option 'tenant_id', tenant_id
  end

  def drive_id
    options&.fetch 'drive_id', nil
  end
  alias_method :drive_id?, :drive_id

  def drive_id= drive_id
    assign_option 'drive_id', drive_id
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end
