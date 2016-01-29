module Issues::Scopes
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where.not status: 'closed' }
  end

  module ClassMethods
    def script_scoped script
      joins(:script).where scripts: { id: script.id }
    end

    def by_id id
      where id: id
    end

    def by_status status
      where status: status
    end

    def by_description description
      where "#{table_name}.description ILIKE ?", "%#{description}%"
    end
  end
end
