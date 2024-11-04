# frozen_string_literal: true

ENABLE_WEB_CONSOLE = ENV['ENABLE_WEB_CONSOLE'] == 'true'
# Ruby SecureRandom.uuid regex match
UUID_REGEX = /[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}/
# Python PonyORM REGEX
PONY_CONNECTION_REGEX = /@pony_connection\[['"](\w+)['"]\]/
# Python SQLAlchemyORM REGEX
SQLALCHEMY_CONNECTION_REGEX = /@sqlalchemy_connection\[['"](\w+)['"]\]/
# Python ODBC REGEX
PY_GREDIT_CONNECTION_REGEX = /gredit.connect\(?\s*['"](\w+)['"]\s*\)?/
# Gredit Cipher
GREDIT_CIPHER = { 'AES-256-CBC': { algorithm: 'algorithms.AES(%{key})', mode: 'modes.CBC(%{iv})' } }
# Python Version
LOCAL_PYTHON_VERSION = %x{python3 --version}.split(' ').last.split('.')[..1].join('.') rescue 'undefined'
