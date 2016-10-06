module Servers::Command
  extend ActiveSupport::Concern

  def execute script
    script_path = script.copy_to self

    if script_path.blank?
      return {
        status: 'error',
        output: 'Script transfer failed'
      }
    end

    if local?
      execute_local  script_path
    else
      execute_remote script_path
    end
  rescue => ex
    { status: 'error', output: ex.to_s }
  end

  private

    def rails
      "#{Rails.root}/bin/rails"
    end

    def execute_local script_path
      stdout, stderr, status = Open3.capture3 rails, 'runner', script_path
      status_text            = "\nExit status: #{status}" unless status.to_i == 0

      {
        status: status.to_i == 0 ? 'ok' : 'error',
        output: [stdout, stderr].join + status_text.to_s
      }
    end

    def execute_remote script_path
      out = {}

      Net::SSH.start hostname, user, ssh_options do |ssh|
        ssh.exec! "chmod +x #{script_path}"

        out = ssh_exec! ssh, "$SHELL -ci #{script_path}"

        ssh.exec! "rm #{script_path}"
      end

      status_text = "\nExit status: #{status}" unless out[:exit_code] == 0

      {
        status: out[:exit_code] == 0 ? 'ok' : 'error',
        output: out[:output].to_s + status_text.to_s
      }
    end

    def ssh_exec! ssh, command
      output    = ''
      exit_code = nil

      ssh.open_channel do |channel|
        channel.exec command do |ch, success|
          raise "FAILED: couldn't execute command" unless success

          channel.on_data          { |ch, data|       output << data }
          channel.on_extended_data { |ch, type, data| output << data }

          channel.on_request 'exit-status' do |ch, data|
            exit_code = data.read_long
          end
        end
      end

      ssh.loop

      { output: output, exit_code: exit_code }
    end
end
