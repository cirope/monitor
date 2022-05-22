module Scripts::Callbacks
  extend ActiveSupport::Concern

  included do
    after_initialize :assign_default_language
  end

  private

    def assign_default_language
      self.language = 'ruby' if language.blank?
    end
end
