# frozen_string_literal: true

module Users::Visibility
  extend ActiveSupport::Concern

  def hide
    current_membership.destroy!

    update hidden: true
  end

  def visible?
    !hidden
  end

  module ClassMethods
    def hide
      all.update_all hidden: true
    end
  end
end
