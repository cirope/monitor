module Roles
  extend ActiveSupport::Concern

  User::ROLES.each do |role|
    define_method "not_#{role}" do
      not_authorized_redirect current_user.send("#{role}?")
    end

    define_method "only_#{role}" do
      not_authorized_redirect !current_user.send("#{role}?")
    end
  end

  private

    def not_authorized_redirect condition
      redirect_to issues_url, alert: t('messages.not_authorized') if condition
    end
end
