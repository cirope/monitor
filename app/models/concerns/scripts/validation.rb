# frozen_string_literal: true

module Scripts::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :name, :change, length: { maximum: 255 }
    validates :text, pdf_encoding: true
    validates :text, syntax: true, if: :ruby?
    validates :database, presence: true, if: :sql?
    validate :change_on_text_changed?
    validate :text_or_file_present?, unless: :container?
    validate :no_text_and_file?
    validate :compatible_version?, if: :imported_version
  end

  private

    def change_on_text_changed?
      if text_changed? && text.present? && change.blank?
        errors.add :change, :blank
      end
    end

    def text_or_file_present?
      # TODO: change to attachment.blank? on Rails 6 (on 5.2 it does not work)
      errors.add :text, :blank if text.blank? && !attachment.attached?
    end

    def no_text_and_file?
      errors.add :attachment, :invalid if text.present? && attachment.attached?
    end

    def compatible_version?
      errors.add :imported_version, :invalid unless imported_version == current_version
    end
end
