# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  extend ApplicationHelper

  helper :application
  helper :mailer

  default from: "'#{app_name}' <#{ENV['EMAIL_ADDRESS']}>"
  layout 'mailer'

  def current_account
    @current_account ||= Account.find_by tenant_name: Apartment::Tenant.current
  end
  helper_method :current_account
end
