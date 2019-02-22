module Accounts::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :tenant_name, presence: true
    validates :name, length: { maximum: 255 }
    validates :tenant_name, uniqueness: true, format: { with: /\A[a-z_]+\z/ }
    validates :tenant_name, length: { maximum: 63 }, format: {
      without: /\Apg_/
    }, exclusion: {
      in: %w(public)
    }
  end
end
