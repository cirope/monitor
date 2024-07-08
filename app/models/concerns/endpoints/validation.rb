module Endpoints::Validation
  extend ActiveSupport::Concern

  included do
    validates :name,
      uniqueness: { case_sensitive: false }
    validates :name, :provider,
      presence: true,
      length: { maximum: 255 }
    validates :provider, inclusion: { in: Endpoint.providers.keys }

    with_options if: :dynamics? do |dynamics|
      dynamics.validates *required_options(:dynamics),
        presence: true,
        length: { maximum: 255 }
    end
  end
end
