# frozen_string_literal: true

module FlashHelper
  def flash_message
    flash[:alert] || flash[:notice]
  end

  def flash_classes
    if flash[:alert]
      'alert-danger'
    else
      'alert-info'
    end
  end
end
