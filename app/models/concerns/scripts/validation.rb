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
      errors.add :change, :blank if text_changed? && change.blank?
    end

    def text_or_file_present?
      errors.add :text, :blank if text.blank? && file.blank?
    end

    def no_text_and_file?
      errors.add :file, :invalid if text.present? && file.present?
    end
end
