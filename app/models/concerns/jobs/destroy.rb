# frozen_string_literal: true

module Jobs::Destroy
  extend ActiveSupport::Concern

  def destroy
    JobDestroyJob.perform_later self

    update hidden: true
  end
end
