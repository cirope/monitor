module Users::Notifications
  extend ActiveSupport::Concern

  def notify_recent_issues time = 10.minutes
    recent_issues = recent_issues_from time

    if recent_issues.exists?
      permalink = Permalink.create! issue_ids: recent_issues.ids

      Notifier.recent_issues(user:      self,
                             permalink: permalink).deliver_later
    end
  end

  module ClassMethods
    def notify_recent_issues_all_users time = 10.minutes
      with_recent_issues(time).find_each do |user|
        user.notify_recent_issues time
      end
    end

    private

      def with_recent_issues time
        now        = Time.zone.now
        created_on = now - time

        joins(:issues).
          where(
            issues: { status: 'pending', created_at: created_on...now }
          ).
          distinct
      end
  end

  private

    def recent_issues_from time
      now        = Time.zone.now
      created_on = now - time

      issues.
        where(
          issues: { status: 'pending', created_at: created_on...now }
        )
    end
end
