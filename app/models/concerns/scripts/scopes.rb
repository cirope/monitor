module Scripts::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order :name }
  end

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end
  end
end
