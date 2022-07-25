module Drives::MountPoint
  extend ActiveSupport::Concern

  included do
    after_create_commit :create_mount_point
    after_destroy :umount_drive
  end

  def mount_point
    File.join Dir.home, section
  end

  def mount_drive
    Open3.popen3 "rclone mount #{section}: #{mount_point}"
  end

  def umount_drive
    system "fusermount -uz #{mount_point}"
  end

  private

    def create_mount_point
      FileUtils.mkdir_p mount_point
    end
end
