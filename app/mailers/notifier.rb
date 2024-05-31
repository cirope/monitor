# frozen_string_literal: true

class Notifier < ApplicationMailer
  def notify message
    message = message.with_indifferent_access
    @body   = message[:body]

    Hash(message[:attachments]).each do |filename, file|
      attachments[filename] = file
    end

    mail to:      message[:to],
         cc:      message[:cc],
         bcc:     message[:bcc],
         subject: message[:subject]
  end

  def issue issue, to, data_as_csv: false
    @issue       = issue
    @data_as_csv = data_as_csv

    if data_as_csv
      issue.export_attachment.each do |filename, content|
        attachments[filename] = content
      end
    end

    mail to: to
  end

  def issues user:, permalink:
    @permalink = permalink

    mail to: user.email
  end

  def comment comment, users
    @comment = comment
    @issue   = comment.issue

    mail to: users.map(&:email)
  end

  def mass_comment user:, comment:, permalink:
    @comment   = comment
    @permalink = permalink

    mail to: user.email
  end
end
