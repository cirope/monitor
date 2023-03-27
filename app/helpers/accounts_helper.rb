# frozen_string_literal: true

module AccountsHelper
  def token_frequencies
    %w(minutes hours days weeks months years).map do |frequency|
      [t("accounts.token_frequencies.#{frequency}"), frequency]
    end
  end
end
