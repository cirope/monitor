module Libraries::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, length: { maximum: 255 },
      uniqueness: { scope: :script }
    validate :unique_name, if: :new_record?
  end

  private

    def unique_name
      others = script.libraries.reject do |p|
        (id && p.id == id) || (id.nil? && p.object_id == object_id)
      end

      if others.any? { |p| p.name == name }
        errors.add :name, :taken
      end
    end
end
