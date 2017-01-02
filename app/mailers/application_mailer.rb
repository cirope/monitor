class ApplicationMailer < ActionMailer::Base
  extend ApplicationHelper
  include Roadie::Rails::Automatic

  add_template_helper ApplicationHelper
  add_template_helper MailerHelper

  default from: "'#{app_name}' <#{ENV['EMAIL_ADDRESS']}>"
  layout 'mailer'
end
