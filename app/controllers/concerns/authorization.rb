module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize
  end

  private

    def authorize
      unless current_user&.visible? &&
                    current_account &&
                    current_user&.can?(action_name, controller_path)
        redirect_to login_url, alert: t('messages.not_authorized')
      end
    end
end
