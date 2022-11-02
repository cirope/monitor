# frozen_string_literal: true

ENABLE_WEB_CONSOLE = ENV['ENABLE_WEB_CONSOLE'] == 'true'
# Ruby SecureRandom.uuid regex match
UUID_REGEX = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/
# Python pony regex
PONY_CONNECTION_REGEX = /@pony_connection\[['"](\w+)['"]\]/
# Gredit Cipher
GREDIT_CIPHER = { 'AES-256-CBC': { algorithm: 'algorithms.AES(%{key})', mode: 'modes.CBC(%{iv})' } }
