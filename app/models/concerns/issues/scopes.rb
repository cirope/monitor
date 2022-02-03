# frozen_string_literal: true

module Issues::Scopes
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where.not status: 'closed' }
    scope :ordered_by_script_name, -> { reorder "#{Script.table_name}.name" }
    scope :ordered_by_schedule_name, -> { reorder "#{Schedule.table_name}.name" }
  end

  module ClassMethods
    def script_scoped script
      script_id_scoped script.id
    end

    def script_id_scoped script_id
      joins(:script).where scripts: { id: script_id }
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

    def by_scheduled_at range_as_string
      includes(:run).references(:run).merge(Run.by_scheduled_at(range_as_string))
    end

    def grouped_by_script schedule_id = nil
      scoped = if schedule_id
                 joins(:schedule).where schedules: { id: schedule_id }
               else
                 all
               end

      scoped.joins(:script).group "#{Script.table_name}.id", "#{Script.table_name}.name"
    end

    def grouped_by_schedule
      joins(:schedule).group "#{Schedule.table_name}.id", "#{Schedule.table_name}.name"
    end

    def by_canonical_data data_keys
      query = data_keys.to_h
                       .map { |k, v| ActiveRecord::Base.sanitize_sql_array(['canonical_data ->> ? like ?', k, "%#{v}%"]) if v.present? }
                       .compact
                       .join(' AND ')

      where(query)
    end
  end
end
