class Notifier < ApplicationMailer
  def notify message
    message = message.with_indifferent_access
    @body   = message[:body]

    (message[:attachments] || {}).each do |filename, file|
      attachments[filename] = file
    end

    mail to:      message[:to],
         cc:      message[:cc],
         bcc:     message[:bcc],
         subject: message[:subject]
  end

  def issue issue, to
    @issue = issue

    mail to: to
  end

  def comment comment, users
    @comment = comment
    @issue   = comment.issue

    mail to: users.map(&:email)
  end
end
