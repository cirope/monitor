# frozen_string_literal: true

module Schedules::Destroy
  extend ActiveSupport::Concern

  def destroy
    if cleanup
      super
    else
      update hidden: true
    end
  end
end
