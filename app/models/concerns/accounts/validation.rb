# frozen_string_literal: true

module Accounts::Validation
  extend ActiveSupport::Concern

  STYLES = ['default', 'primary', 'secondary', 'success', 'info', 'warning', 'danger', 'dark']

  included do
    validates :name, :tenant_name, :token_interval, :token_frequency,
      :cleanup_runs_after, :cleanup_executions_after, :rows_per_page,
      presence: true
    validates :name, length: { maximum: 255 }
    validates :token_interval, :rows_per_page,
      numericality: { only_integer: true, greater_than_or_equal_to: 1 }
    validates :token_frequency, inclusion: { in: %w(minutes hours days weeks months years) }
    validates :cleanup_runs_after, :cleanup_executions_after,
      numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 1_000_000 },
      allow_nil: true, allow_blank: true
    validates :style, inclusion: { in: STYLES }
    validates :tenant_name, uniqueness: true, format: { with: /\A[a-z_]+\z/ }
    validates :tenant_name, length: { maximum: 63 }, format: {
      without: /\Apg_/
    }, exclusion: {
      in: %w(public)
    }
  end
end
