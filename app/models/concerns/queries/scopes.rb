# frozen_string_literal: true

module Queries::Scopes
  extend ActiveSupport::Concern

  def generate_data
    case output
    when 'pie', 'donut' then polar_data
    else series_data
    end
  end

  def common_data
    conditions = {}
    conditions[:name] = filters
    conditions[:date] = from_at..to_at if period != 'total'

    Serie.where(conditions).group(:name).send(function, :amount).sort.map { |k,v| [ k, v.round] }
  end

  def series_data
    { name: I18n.t("queries.functions.#{function}"), data: common_data }
  end

  def polar_data
    common_data.map { |k,v| { name: k, data: v } }
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

  module ClassMethods
    def filters
      Serie.distinct.pluck :name
    end
  end

  private

    def calculate_date
      range ? get_range : get_period
    end
end
