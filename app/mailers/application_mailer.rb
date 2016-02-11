class ApplicationMailer < ActionMailer::Base
  extend ApplicationHelper
  include Roadie::Rails::Automatic

  add_template_helper ApplicationHelper

  default from: "'#{app_name}' <#{ENV['EMAIL_ADDRESS']}>"
  layout 'mailer'
end
