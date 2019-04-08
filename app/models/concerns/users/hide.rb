# frozen_string_literal: true

module Users::Hide
  extend ActiveSupport::Concern

  def hide
    current_membership.destroy!

    update hidden: true
  end

  module ClassMethods
    def hide
      all.update_all hidden: true
    end
  end
end
