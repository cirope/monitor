# frozen_string_literal: true

EXPORTS_PATH = Rails.root + 'private/exports'
ENABLE_WEB_CONSOLE = ENV['ENABLE_WEB_CONSOLE'] == 'true'
# Ruby SecureRandom.uuid regex match
UUID_REGEX = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/
