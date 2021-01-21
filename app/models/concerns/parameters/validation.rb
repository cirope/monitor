# frozen_string_literal: true

module Parameters::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :value, presence: true, format: { without: /[\[\]]/ }
    validates :name, length: { maximum: 255 }, uniqueness: { scope: :script }
    validate :unique_name, if: :new_record?
  end

  private

    # Just for cases when two parameters with the same name are new
    def unique_name
      others = script.parameters.reject do |p|
        (id && p.id == id) || (id.nil? && p.object_id == object_id)
      end

      if others.any? { |p| p.name == name }
        errors.add :name, :taken
      end
    end
end
