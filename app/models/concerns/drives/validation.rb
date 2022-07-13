module Drives::Validation
  extend ActiveSupport::Concern

  included do
    PROVIDERS = ['drive']

    validates :name, :identifier, uniqueness: { case_sensitive: false }
    validates :name, :identifier, :client_id, :client_secret,
      presence: true,
      length: { maximum: 255 }
    validates :provider, inclusion: { in: PROVIDERS }
  end
end
