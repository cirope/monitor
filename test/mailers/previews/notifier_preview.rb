# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notifier/notify
  def notify
    Notifier.notify to: 'test@monitor.com', body: 'Test body'
  end
end
