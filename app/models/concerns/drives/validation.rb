module Drives::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :identifier,
      uniqueness: { case_sensitive: false }
    validates :provider, :name, :identifier, :client_id, :client_secret,
      presence: true,
      length: { maximum: 255 }
    validates :provider, inclusion: { in: Drive::PROVIDERS }

    with_options if: :drive? do |drive|
      drive.validates :root_folder_id,
        presence: true,
        length: { maximum: 255 }
    end

    with_options if: :is_onedrive? do |onedrive|
      onedrive.validates :tenant_id, :drive_id,
        presence: true,
        length: { maximum: 255 }
    end
  end

  private

    def is_onedrive?
      onedrive? || sharepoint?
    end
end
