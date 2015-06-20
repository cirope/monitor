module Scripts::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :name, length: { maximum: 255 }
    validate :text_or_file_present?
    validate :no_text_and_file?
  end

  private

    def text_or_file_present?
      errors.add :text, :blank if text.blank? && file.blank?
    end

    def no_text_and_file?
      errors.add :file, :invalid if text.present? && file.present?
    end
end
