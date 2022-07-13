# frozen_string_literal: true

class Drive < ApplicationRecord
  include Attributes::Strip
  include Drives::Defaults
  include Drives::Providers
  include Drives::GoogleDrive
  include Drives::Validation
  include PublicAuditable

  scope :ordered, -> { order :name }

  strip_fields :name, :client_id, :client_secret

  belongs_to :account

  def to_s
    name
  end
end
