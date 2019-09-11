# frozen_string_literal: true

module Scripts::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :name, :change, length: { maximum: 255 }
    validates :text, syntax: true, pdf_encoding: true
    validate :change_on_text_changed?
    validate :text_or_file_present?
    validate :no_text_and_file?
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
end
