module Jobs::Destroy
  extend ActiveSupport::Concern

  def destroy
    if cleanup
      super
    else
      update hidden: true
    end
  end
end
