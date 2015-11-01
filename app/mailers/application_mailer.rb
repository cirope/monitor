class ApplicationMailer < ActionMailer::Base
  default from: "'#{I18n.t('app_name')}' <#{ENV['EMAIL_ADDRESS']}>"
  layout 'mailer'
end
