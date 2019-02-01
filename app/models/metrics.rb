class Metrics < ApplicationRecord
  self.abstract_class = true
  self.table_name_prefix = 'metrics_'

  # establish_connection :"metrics_#{Rails.env}"
  def self.metrics_increment(user_id, amount)
    result = self.connection.execute(
      "SELECT metrics_increment('#{table_name}', '#{user_id}', #{amount});"
    )

    result.first['metrics_increment']
  end
end
