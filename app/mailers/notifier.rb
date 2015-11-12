class Notifier < ApplicationMailer
  def notify message
    @body = message[:body]

    mail to: message[:to], subject: message[:subject]
  end

  def issue issue, to
    @issue = issue

    mail to: to
  end

  def comment comment, users
    @comment = comment

    mail to: users.map(&:email)
  end
end
