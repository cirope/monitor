# frozen_string_literal: true

class MountDrivesJob < ApplicationJob
  queue_as :default

  def perform
    Drive.mount_all
  end
end
