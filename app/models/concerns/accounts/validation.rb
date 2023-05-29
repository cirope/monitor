# frozen_string_literal: true

module Accounts::Validation
  extend ActiveSupport::Concern

  STYLES = ['default', 'primary', 'secondary', 'success', 'info', 'warning', 'danger', 'dark']

  included do
    validates :name, :tenant_name, presence: true
    validates :name, length: { maximum: 255 }
    validates :style, inclusion: { in: STYLES }
    validates :tenant_name, uniqueness: true, format: { with: /\A[a-z_]+\z/ }
    validates :tenant_name, length: { maximum: 63 }, format: {
      without: /\Apg_/
    }, exclusion: {
      in: %w(public)
    }
  end
end
