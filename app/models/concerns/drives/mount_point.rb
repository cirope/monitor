module Drives::MountPoint
  extend ActiveSupport::Concern

  def mount_point
    File.join "#{Rails.root}/drives", section
  end

  def mount_drive
    systemctl_drive 'start'
  end

  def umount_drive
    systemctl_drive 'stop'
  end

  def umount_previous_drive
    systemctl_previous_drive 'stop'
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

    def systemctl_drive action
      system 'systemctl', '--user', action, section
    end

    def systemctl_previous_drive action
      system 'systemctl', '--user', action, previous_section
    end
end
