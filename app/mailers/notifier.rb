class Notifier < ApplicationMailer
  def notify message
    @body = message[:body]

    mail to: message[:to]
  end
end
