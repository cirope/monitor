module Drives::Validation
  extend ActiveSupport::Concern

  included do
    PROVIDERS = ['google']

    validates :name, uniqueness: { case_sensitive: false }
    validates :name, :client_id, :client_secret, presence: true,
      length: { maximum: 255 }
    validates :provider, inclusion: { in: PROVIDERS }
  end
end
