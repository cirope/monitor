module Drives::Validation
  extend ActiveSupport::Concern

  included do
    PROVIDERS = ['drive']

    validates :name, :identifier,
      uniqueness: { case_sensitive: false }
    validates :name, :identifier, :client_id, :client_secret,
      presence: true,
      length: { maximum: 255 }
    validates :provider, inclusion: { in: PROVIDERS }
    validates :root_folder_id, length: { maximum: 255 },
      allow_nil: true, allow_blank: true
  end
end
