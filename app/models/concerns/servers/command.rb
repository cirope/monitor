module Servers::Command
  extend ActiveSupport::Concern

  def execute script
    status      = 'error'
    output      = nil
    script_path = script.copy_to self

    Net::SSH.start hostname, user, ssh_options do |ssh|
      ssh.exec! "chmod +x #{script_path}"

      ssh.exec! "#{script_path}" do |channel, stream, data|
        status = 'ok' unless stream == :stderr
        output = data
      end

      ssh.exec! "rm #{script_path}"
    end

    { status: status, output: output }
  end
end
