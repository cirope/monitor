# frozen_string_literal: true

module Issues::Url
  extend ActiveSupport::Concern

  def url
    Rails.application.routes.url_helpers.account_issue_url(
      Current.account, self, host: ENV['APP_HOST'], protocol: ENV['APP_PROTOCOL']
    )
  end
end
