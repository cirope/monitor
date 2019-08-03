# frozen_string_literal: true

module Servers::Command
  extend ActiveSupport::Concern

  def execute run
    script_path = run.script.copy_to self

    if script_path.blank?
      return {
        status: 'error',
        output: 'Script transfer failed'
      }
    end

    output = []

    status = exec run, script_path do |data|
      output << data
    end

    { status: status, output: output.compact.join }
  rescue => ex
    { status: 'error', output: ex.to_s }
  end

  def execution execution
    script_path = execution.script.copy_to self

    exec execution, script_path do |line|
      execution.new_line line
    end
  end

  def exec executable, script_path
    method = local? ? :local_exec : :remote_exec
    exit_status = send(method, script_path, executable) do |line|
      yield line
    end

    if executable.reload.killed?
      'killed'
    elsif exit_status.zero?
      executable.class.success_status
    else
      yield "Exit status: #{exit_status}"

      'error'
    end
  end

  private

    def rails
      "#{Rails.root}/bin/rails"
    end

    def local_exec script_path, executable
      status = 1

      Open3.popen2e rails, 'runner', script_path do |stdin, stdout, thread|
        executable.update! pid: thread.pid

        stdout.each { |line| yield "#{line.strip}\n" if line }

        status = thread.value.exitstatus.to_i
      end

      status
    end

    def remote_exec script_path, _executable = nil
      status = 1

      Net::SSH.start hostname, user, ssh_options  do |ssh|
        # script permission
        ssh.exec! "chmod +x #{script_path}"

        status = ssh_exec_with_pty ssh, "$SHELL -c #{script_path}" do |data|
          data.to_s.split("\n").each do |line|
            yield "#{line}\n"
          end
        end

        # Clean the script
        ssh.exec! "rm #{script_path}"
      end

      status
    end

    def ssh_exec_with_pty ssh, command
      status = 1

      channel = ssh.open_channel do |och|
        # Realtime log output
        och.request_pty

        # Command execution
        och.exec command do |ch, success|
          # STDOUT
          ch.on_data do |_ch, data|
            yield data
          end

          # STDERR
          ch.on_extended_data do |_ch, _type, data|
            yield data
          end

          # Command status
          ch.on_request 'exit-status' do |_ch, data|
            status = data.read_long
          end
        end
      end

      # Wait until the command finish
      channel.wait

      status
    end
end
