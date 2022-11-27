module Users::Notifications
  extend ActiveSupport::Concern

  def notify_recent_issues time
    recent_issues = recent_issues_from time

    if recent_issues.exists?
      permalink     = Permalink.create! issue_ids: recent_issues.ids

      Notifier.recent_issues(user:      self,
                             permalink: permalink).deliver_later
    end
  end

  module ClassMethods
    def notify_recent_issues_all_users time
      with_recent_issues(time).find_each do |user|
        user.notify_recent_issues time
      end
    end

    private

      def with_recent_issues time
        recent_at = Time.zone.now - time

        joins(:issues).
          where('issues.created_at >= :recent_at', recent_at: recent_at).
          distinct
      end
  end

  private

    def recent_issues_from time
      recent_at = Time.zone.now - time

      issues.where('issues.created_at >= :recent_at', recent_at: recent_at)
    end
end
