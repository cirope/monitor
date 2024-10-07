module Sessions
  extend ActiveSupport::Concern

  private

    def default_url
      session.delete(:previous_url) || home_url
    end

    def create_login_record user
      login = user.logins.create! request: request

      session[:login_id] = login.id
    end

    def store_username username
      session[:username] = username
    end

    def store_current_account account
      session[:tenant_name] = account.tenant_name
    end

    def store_auth_token user
      jar = params[:remember_me] ? cookies.permanent : cookies

      jar.encrypted[:token] = {
        value:    user.auth_token,
        secure:   Rails.application.config.force_ssl,
        httponly: true
      }
    end

    def create_fail_record user, user_name
      Fail.create! user: user, user_name: user_name, request: request
    end

    def clear_session
      reset_session
      cookies.delete :token
    end

    def switch_to_default_account_for username
      account = Account.default_by_username_or_email username

      if account
        account.switch { yield account }
      else
        yield nil
      end
    end

    def set_rows_per_page account
      rows_per_page = account.rows_per_page || 10

      Kaminari.config.default_per_page = rows_per_page.to_i
    end
end
