# frozen_string_literal: true

module Issues::Validation
  extend ActiveSupport::Concern

  OWNER_TYPES = ['Script', 'Rule']

  included do
    validates :status, presence: true, inclusion: { in: :next_status }
    validates :description, pdf_encoding: true
    validate :requires_comment, if: :status_changed?
    validate :has_final_tag
    validate :user_can_modify

    with_options if: :ticket? do |ticket|
      ticket.validates :title, presence: true
      ticket.validates :owner_type, presence: true
    end
  end

  private

    def requires_comment
      user = Current.user

      if user&.owner? && comments.detect(&:new_record?).blank?
        errors.add :comments, :blank
      end
    end

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
