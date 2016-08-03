module Users::Destroy
  extend ActiveSupport::Concern

  def destroy
    update hidden: true
  end

  module ClassMethods
    def hide
      all.update_all hidden: true
    end
  end
end
