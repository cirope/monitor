module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :authorize
  end

  private

    def authorize
      unless current_user&.visible? &&
                    current_account &&
                    current_user&.can?(set_action, controller_path)
        redirect_to login_url, alert: t('messages.not_authorized')
      end
    end

    def set_action
      case action_name.to_s
        when 'index', 'show' then 'read'
        when 'new', 'create', 'edit', 'update' then 'edit'
        when 'destroy' then 'remove'
        end
    end
end
