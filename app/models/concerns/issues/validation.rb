module Issues::Validation
  extend ActiveSupport::Concern

  included do
    validates :status, presence: true, inclusion: { in: :next_status }
    validate :has_final_tag
  end

  private

    def has_final_tag
      if closed?
        tags       = taggings.reject(&:marked_for_destruction?).map(&:tag)
        final_tags = tags.select(&:final?)

        errors.add :tags, :invalid unless final_tags.size == 1
      end
    end
end
