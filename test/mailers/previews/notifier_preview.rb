# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifier/notify
  def notify
    Notifier.notify to: 'test@monitor.com', body: 'Test body'
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/issue
  def issue
    Notifier.issue Issue.where.not(data: nil).take, ['test@monitor.com']
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/comment
  def comment
    comment = Comment.take

    Notifier.comment comment, comment.users
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifier/mass_comment
  def mass_comment
    user      = User.take
    comment   = Comment.take
    permalink = Permalink.take

    Notifier.mass_comment user: user, comment: comment, permalink: permalink
  end
end
