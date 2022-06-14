module Sessions
  extend ActiveSupport::Concern

  private

    def default_url
      session.delete(:previous_url) || home_url
    end

    def store_current_user user
      session[:current_user_id] = user.id
    end

    def store_current_account account
      session[:tenant_name] = account.tenant_name
    end

    def create_fail_record user, user_name
      Fail.create! user: user, user_name: user_name, request: request
    end

    def switch_to_default_account_for username
      @account = Account.default_by_username_or_email username

      if @account
        @account.switch { yield @account }
      else
        yield nil
      end
    end

    def clear_session
      reset_session
      cookies.delete :token
    end
end
