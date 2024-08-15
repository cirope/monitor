# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifier/notify
  def notify
    Notifier.notify to: 'test@monitor.com', body: 'Test body'
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/issue
  def issue
    with_account!

    Notifier.issue Issue.where.not(data: nil).take, ['test@monitor.com']
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/recent_issues
  def recent_issues
    with_account!

    user      = User.take
    issues    = Issue.all.limit 10
    permalink = Permalink.create issue_ids: issues.ids

    Notifier.recent_issues user: user, permalink: permalink
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/comment
  def comment
    with_account!

    comment = Comment.where.not(issue_id: nil).take!

    Notifier.comment comment, comment.users
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/mass_comment
  def mass_comment
    with_account!

    user      = User.take
    comment   = Comment.take
    permalink = Permalink.take

    Notifier.mass_comment user: user, comment: comment, permalink: permalink
  end

  private

    def with_account!
      account = Current.account || Account.order(:id).first

      account.switch!
    end
end
