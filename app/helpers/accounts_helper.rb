# frozen_string_literal: true

module AccountsHelper
  def token_frequencies
    %w(minutes hours days weeks months years).map do |frequency|
      [t("accounts.token_frequencies.#{frequency}"), frequency]
    end
  end

  def account_styles
    %w(default primary secondary success info warning danger dark).map do |style|
      [t("accounts.styles.#{style}"), style]
    end
  end

  def current_account_style
    "text-bg-#{current_account.style}" if current_account.style.present?
  end
end
