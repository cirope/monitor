# frozen_string_literal: true

module PdfTemplates::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true,
                     uniqueness: { case_sensitive: false },
                     length: { maximum: 255 }
    validate :content_present
  end

  private

    def content_present
      errors.add :base, 'El contenido no puede ser vacio' if content.blank?
    end
end
