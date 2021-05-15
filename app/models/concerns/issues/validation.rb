# frozen_string_literal: true

module Issues::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: :next_status }
    validates :description, pdf_encoding: true
    validate :has_final_tag
    validate :user_can_modify
  end

  private

    def has_final_tag
      if closed?
        tags       = taggings.reject(&:marked_for_destruction?).map(&:tag)
        final_tags = tags.select(&:final?)

        errors.add :tags, :invalid unless final_tags.size == 1
      end
    end

    def user_can_modify
      user = Current.user

      if user&.author? && users.exclude?(user)
        errors.add :base, :user_invalid
      end
    end
end
