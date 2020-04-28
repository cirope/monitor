module Panels::Scopes
  extend ActiveSupport::Concern

  def generate_data
    conditions = {}
    conditions[:name] = filters if filters.present?
    conditions[:date] = calculate_date if period != 'total'

    Serie.where(conditions).group(:name).send(function, :amount)
  end

  private

    def calculate_date
      range ? get_range : get_period
    end

    def get_range
    end

    def get_period
      now = Time.zone.now

      case period
        when 'day'   then now.all_day
        when 'week'  then now.all_week
        when 'month' then now.all_month
        when 'year'  then now.all_year
      end
    end
end
