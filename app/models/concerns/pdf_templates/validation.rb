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
      if content.blank?
        errors.add :content, :blank
        errors.add :base, :content_blank
      end
    end
end
