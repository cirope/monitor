class ScriptOrScheduleWithIssuesViewsDecorator < SimpleDelegator
  def to_a
    get_counts_issues_and_views
  end

  private

    def grouped_by_script_or_schedule
      group_by { |k, _v| [k.first, k.second] }
    end

    def concat_views_by_user
      grouped_by_script_or_schedule.map do |k, v|
        [k].concat(v.map { |k_with_user| k_with_user.first.third }).concat(v.map(&:last))
      end
    end

    def get_counts_issues_and_views
      concat_views_by_user.map do |e|
        [e.first].concat((e.count == 5 ? [e.fourth + e.last, e.last] : [e.last, (e.second.present? ? 0 : e.last)]))
      end
    end
end
