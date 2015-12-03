module Roles
  extend ActiveSupport::Concern

  User::ROLES.each do |role|
    define_method "not_#{role}" do
      redirect_to issues_url, alert: t('messages.not_authorized') if current_user.send("#{role}?")
    end

    define_method "only_#{role}" do
      redirect_to issues_url, alert: t('messages.not_authorized') unless current_user.send("#{role}?")
    end
  end
end
