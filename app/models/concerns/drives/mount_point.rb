module Drives::MountPoint
  extend ActiveSupport::Concern

  def mount_point
    File.join "#{Rails.root}/drives", section
  end

  def mount_drive
    system 'systemctl', '--user', 'start', section
  end

  def umount_drive
    system 'systemctl', '--user', 'stop', section
  end

  module ClassMethods
    def mount_all
      Drive.all.map &:mount_drive
    end

    def umount_all
      Drive.all.map &:umount_drive
    end
  end
end
