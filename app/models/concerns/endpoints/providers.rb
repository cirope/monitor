module Endpoints::Providers
  extend ActiveSupport::Concern

  included do
    enum provider: {
      dynamics: 'dynamics',
    }
  end

  def process
    send "#{provider}_process"
  end
end
