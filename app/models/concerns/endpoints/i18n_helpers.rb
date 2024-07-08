module Endpoints::I18nHelpers
  extend ActiveSupport::Concern

  def i18n_provider
    I18n.t "endpoints.providers.#{provider}"
  end

  module ClassMethods
    def i18n_provider provider
      I18n.t "endpoints.providers.#{provider}"
    end

    def i18n_provider_option provider:, option:
      I18n.t "endpoints.providers.options.#{provider}.#{option}"
    end
  end
end
