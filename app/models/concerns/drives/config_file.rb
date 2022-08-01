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

  def create_section
    system config_file_cmd('create')
  end

  def update_config code
    token = send "#{provider}_config", code

    system config_file_cmd('update', "token '#{token}'")

    mount_drive
  end

  private

    def update_section
      umount_drive

      system config_file_cmd('update')
    end

    def delete_section
      umount_drive

      system "rclone config delete #{section}"
    end

    def config_file_cmd action, extras = nil
      cmd = [
        "rclone config #{action}",
        "#{section}",
        'config_is_local false',
        "client_id #{client_id}",
        "client_secret #{client_secret}",
        extras
      ].compact

      cmd.insert(2, provider) if action == 'create'

      cmd.join ' '
    end
end
