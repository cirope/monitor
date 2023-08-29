module Drives::ConfigFile
  extend ActiveSupport::Concern

  included do
    after_create_commit  :create_section
    after_update_commit  :update_section
    after_destroy_commit :delete_section
  end

  def section
    name.parameterize separator: '_'
  end

  def update_config code
    umount_drive

    system 'rclone', *config_file_cmd('update', send("#{provider}_config", code))

    mount_drive
  end

  private

    def create_section
      system 'rclone', *config_file_cmd('create', try("#{provider}_extra_params"))
    end

    def update_section
      umount_drive

      system 'rclone', *config_file_cmd('update')

      mount_drive
    end

    def delete_section
      system 'rclone', 'config', 'delete', section
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
