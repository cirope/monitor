module Libraries::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, presence: true, length: { maximum: 255 },
      uniqueness: { scope: :script }
    validate :unique_name, if: :new_record?
  end

  private

    def unique_name
      others = script.libraries.reject do |l|
        (id && l.id == id) || (id.nil? && l.object_id == object_id)
      end

      if others.any? { |l| l.name == name }
        errors.add :name, :taken
      end
    end
end
