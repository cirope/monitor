module Drives::ConfigFile
  extend ActiveSupport::Concern

  included do
    after_create_commit  :create_mount_point, :create_section, :create_systemd_file
    after_update_commit  :update_section, :update_systemd_file
    after_destroy_commit :delete_section, :delete_systemd_file
  end

  def section
    name.parameterize separator: '_'
  end

  def previous_section
    name_before_last_save.parameterize separator: '_'
  end

  def update_config code
    umount_drive

    system 'rclone', *config_file_cmd('update', send("#{provider}_config", code))

    mount_drive
  end

  private

    def create_mount_point
      FileUtils.mkdir_p mount_point
    end

    def create_section
      system 'rclone', *config_file_cmd('create', try("#{provider}_extra_params"))
    end

    def delete_mount_point
      umount_drive

      FileUtils.rmdir mount_point if Dir.exist?(mount_point)
    end

    def update_section
      umount_drive

      if saved_change_to_name?
        delete_previous_section
        create_section
      else
        system 'rclone', *config_file_cmd('update')
      end

      mount_drive
    end

    def delete_section
      system 'rclone', 'config', 'delete', section
    end

    def delete_previous_section
      system 'rclone', 'config', 'delete', previous_section
    end

    def config_file_cmd action, extras = nil
      type = try("#{provider}_provider") || provider

      cmd = [
        'config',
        action,
        section,
        'config_is_local=false',
        "client_id=#{client_id}",
        "client_secret=#{client_secret}",
        extras,
        '--non-interactive',
      ].flatten.compact

      cmd.insert(3, type) if action == 'create'

      cmd
    end
end
