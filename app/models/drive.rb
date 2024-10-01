# frozen_string_literal: true

class Drive < ApplicationRecord
  include Attributes::Strip
  include Drives::Callbacks
  include Drives::ConfigFile
  include Drives::MountPoint
  include Drives::Options
  include Drives::Providers
  include Drives::GoogleDrive
  include Drives::OneDrive
  include Drives::SharePoint
  include Drives::Systemd
  include Drives::Validation
  include PublicAuditable

  scope :ordered, -> { order :name }

  strip_fields :name, :client_id, :client_secret,
    :root_folder_id, :drive_id

  belongs_to :account

  def to_s
    name
  end
end
