# frozen_string_literal: true

module FlashHelper
  def flash_message
    flash[:alert] || flash[:notice]
  end

  def flash_classes
    if flash[:alert]
      'alert-danger bg-danger text-white border-0'
    else
      'alert-info'
    end
  end
end
