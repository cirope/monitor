# frozen_string_literal: true

module Jobs::Destroy
  extend ActiveSupport::Concern

  def destroy
    update hidden: true

    JobDestroyJob.perform_later self
  end
end
