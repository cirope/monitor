class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  add_template_helper ApplicationHelper

  default from: "'#{I18n.t('app_name')}' <#{ENV['EMAIL_ADDRESS']}>"
  layout 'mailer'
end
