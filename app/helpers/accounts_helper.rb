# frozen_string_literal: true

module AccountsHelper
  def account_styles
    Account::STYLES.map { |style| [t("accounts.styles.#{style}"), style] }
  end
end
