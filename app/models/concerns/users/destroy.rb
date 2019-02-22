module Users::Destroy
  extend ActiveSupport::Concern

  def destroy
    current_membership.destroy!

    update hidden: true
  end

  module ClassMethods
    def hide
      all.update_all hidden: true
    end
  end
end
