# frozen_string_literal: true

module Issues::Scopes
  extend ActiveSupport::Concern

  included do
    scope :active,  -> { where.not status: 'closed' }
    scope :issues,  -> { where "#{Issue.table_name}.owner_type = 'Run'" }
    scope :ordered, -> { order "#{Issue.table_name}.created_at DESC" }
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

    def grouped_by_script_and_views schedule_id, current_user
      grouped_by_script(schedule_id).grouped_by_views current_user
    end

    def grouped_by_schedule
      joins(:schedule).group "#{Schedule.table_name}.id", "#{Schedule.table_name}.name"
    end

    def grouped_by_schedule_and_views current_user
      grouped_by_schedule.grouped_by_views current_user
    end

    def grouped_by_views current_user
      left_joins(:views).group("#{View.table_name}.user_id")
                        .merge(View.viewed_by(current_user).or(View.where(user_id: nil)))
    end

    def by_canonical_data data_keys
      query = data_keys.to_h
                       .except(:keys_ordered)
                       .select { |_k, v| v.present?}
                       .map { |k, v| like_for_key(data_keys, k, v) }
                       .join(' AND ')

      where(query)
    end

    private

      def like_for_key data_keys, key, value
        keys_ordered = JSON[data_keys[:keys_ordered]]

        like_value = if keys_ordered.last == key
                       %Q(%"#{key}":"%#{value}%"%)
                     else
                       next_key = keys_ordered[keys_ordered.index(key).next]

                       %Q(%"#{key}":"%#{value}%","#{next_key}":%)
                     end

        ActiveRecord::Base.sanitize_sql_array(["#{Issue.table_name}.canonical_data like ?", like_value])
      end
  end
end
