module Drives::MountPoint
  extend ActiveSupport::Concern

  included do
    after_create_commit  :create_mount_point
    after_destroy_commit :delete_mount_point
  end

  def mount_point
    File.join "#{Rails.root}/drives", section
  end

  def mount_drive
    system 'service', section, 'start'
  end

  def umount_drive
    system 'service', section, 'stop'
  end

  module ClassMethods
    def mount_all
      Drive.all.map &:mount_drive
    end

    def umount_all
      Drive.all.map &:umount_drive
    end
  end

  private

    def create_mount_point
      FileUtils.mkdir_p mount_point
    end

    def delete_mount_point
      umount_drive

      FileUtils.rmdir mount_point if Dir.exist?(mount_point)
    end
end
