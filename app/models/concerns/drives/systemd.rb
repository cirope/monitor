module Drives::Systemd
  extend ActiveSupport::Concern

  include do
    after_create_commit  :create_systemd_file
    after_update_commit  :update_systemd_file
    after_destroy_commit :delete_systemd_file
  end

  private

    def systemd_service_name
      "#{section}.service"
    end

    def systemd_file_path
      "/etc/systemd/system/#{systemd_service_name}"
    end

    def systemctl_service action
      system 'systemctl', action, systemd_service_name
    end

    def create_systemd_file
      File.open(systemd_file_path, 'w') do |file|
        file << systemd_file
      end

      systemctl_service 'enable'
    end

    def update_systemd_file
      if saved_change_to_name?
        delete_systemd_file
        create_systemd_file
      end
    end

    def delete_systemd_file
      systemctl_service 'disable'

      system 'rm', systemd_file_path
    end

    def systemd_file
      drive_path = Rails.root.each_filename.to_a[0..2]
      mount_path = File.join '/', drive_path, 'shared', 'drives', section

      <<~RUBY
        [Unit]
        Description=Rclone drive for #{section}
        After=network-online.target
        Wants=network-online.target
        AssertPathIsDirectory=#{mount_path}

        [Service]
        Type=notify
        ExecStart= \
          /usr/bin/rclone mount \
            --config=#{Etc.getpwuid.dir}/.config/rclone/rclone.conf \
            --allow-non-empty \
            --vfs-cache-mode writes \
            --vfs-cache-max-size 100M \
            --vfs-read-chunk-size-limit 128M \
            --vfs-read-chunk-size-limit off \
            --log-level DEBUG \
            --umask 022 \
            --allow-other \
            #{section}: #{mount_path}
        ExecStop=/bin/fusermount -uz #{mount_path}
        Restart=on-abort

        [Install]
        WantedBy=default.target
      RUBY
    end
end
