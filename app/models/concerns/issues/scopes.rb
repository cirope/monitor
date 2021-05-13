# frozen_string_literal: true

module Issues::Scopes
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where.not status: 'closed' }
    scope :ordered_by_script_name, -> { reorder "#{Script.table_name}.name" }
  end

  module ClassMethods
    def script_scoped script
      joins(:script).where scripts: { id: script.id }
    end

    def by_id id
      where id: id
    end

    def by_status status
      status == 'all' ? all : where(status: status)
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

    def by_user_id user_id
      joins(:users).where "#{User.table_name}.id = ?", user_id
    end

    def by_script_name name
      joins(:script).where "#{Script.table_name}.name ILIKE ?", "%#{name}%"
    end

    def by_comment comment
      left_joins(:comments).where "#{Comment.table_name}.text ILIKE ?", "%#{comment}%"
    end

    def by_key key
      where "(#{Issue.table_name}.data ->>1)::json->>-1 = ?", key
    end

    def grouped_by_script
      joins(:script).group "#{Script.table_name}.id", "#{Script.table_name}.name"
    end
  end
end
