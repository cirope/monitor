class ErrorsController < ApplicationController
  before_action do
    response.set_header(
      'Content-Security-Policy', "default-src 'self'; font-src 'self' data:; img-src 'self' data:; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; form-action 'self';"
    )
  end

  def not_found
    respond_to do |format|
      format.html {
        render file: Rails.root.join('public', '404.html'), layout: false, status: :not_found
      }
    end
  end

  def unprocessable_entity
    respond_to do |format|
      format.html {
        render file: Rails.root.join('public', '422.html'), layout: false, status: :unprocessable_entity
      }
    end
  end

  def internal_error
    respond_to do |format|
      format.html {
        render file: Rails.root.join('public', '500.html'), layout: false, status: :internal_server_error
      }
    end
  end
end
