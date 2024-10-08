module Users::Notifications
  extend ActiveSupport::Concern

  def notify_issues issues
    if issues.exists?
      permalink = Permalink.create! issue_ids: issues.ids

      Notifier.issues(user:      self,
                      permalink: permalink).deliver_later
    end
  end

  def notify_recent_issues time = 10.minutes
    notify_issues recent_issues_from(time)
  end

  module ClassMethods
    def notify_recent_issues_all_users time = 10.minutes
      with_recent_issues(time).find_each do |user|
        user.notify_recent_issues time
      end
    end

    private

      def with_recent_issues time
        created_on = Time.zone.now - time

        joins(:issues).
          where(
            issues: { status: 'pending', created_at: created_on... }
          ).
          distinct
      end
  end

  private

    def recent_issues_from time
      created_on = Time.zone.now - time

      issues.
        where(
          issues: { status: 'pending', created_at: created_on... }
        )
    end
end
