module Endpoints::Providers
  extend ActiveSupport::Concern

  included do
    enum provider: {
      dynamics: 'dynamics',
    }
  end
end
