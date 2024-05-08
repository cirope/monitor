module Outputs::Status
  extend ActiveSupport::Concern

  included do
    after_save :update_script_status
  end

  private

    def update_script_status
      script.update_status error?, warning? if finished?
    end
end
