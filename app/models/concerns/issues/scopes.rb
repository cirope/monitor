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

    def by_created_at range_as_string
      dates = range_as_string.split(/\s*-\s*/).map do |d|
        Timeliness.parse d rescue nil
      end
      start  = dates.first
      finish = dates.last

      start && finish ? where(created_at: start..finish) : all
    end

    def by_data data
      where "#{table_name}.data @> ?", data
    end
  end
end
