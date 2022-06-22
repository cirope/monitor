module Samls::Providers
  extend ActiveSupport::Concern

  included do
    PROVIDERS = %w(azure)
  end
end
