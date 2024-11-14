# frozen_string_literal: true

module Scripts::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered,    -> { order :name }
    scope :for_export, -> { joins(:tags).merge Tag.export(true) }
  end

  def is_editable?
    imported_at.blank? || (imported_at.present? && editable?)
  end

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end

    def by_text text
      where "#{table_name}.text ILIKE ?", "%#{text}%"
    end
  end
end
