module Scripts::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order :name }
    scope :with_active_issues, -> {
      where "#{table_name}.active_issues_count > ?", 0
    }
  end

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end
  end
end
