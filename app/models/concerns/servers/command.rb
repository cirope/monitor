# frozen_string_literal: true

module Servers::Command
  extend ActiveSupport::Concern

  def execute run
    script_path = run.script.copy_to self

    if script_path.blank?
      return {
        status: 'error',
        stdout: 'Script transfer failed',
        stderr: 'Script transfer failed'
      }
    end

    stdout = []

    status, stderr = exec run, script_path do |data|
      stdout << data
    end

    { status: status, stdout: stdout.compact.join, stderr: stderr }
  rescue => ex
    { status: 'error', stdout: ex.to_s, stderr: ex.to_s }
  end

  def execution execution
    script_path = execution.script.copy_to self

    exec execution, script_path do |line|
      execution.new_line line
    end
  end

  def exec executable, script_path
    method              = local? ? :local_exec : :remote_exec
    exit_status, stderr = send(method, script_path, executable) do |line|
      yield line
    end

    status = if executable.reload.killed?
      'killed'
    elsif exit_status.zero?
      executable.class.success_status
    else
      yield "Exit status: #{exit_status}"

      'error'
    end

    return status, stderr
  end

  private

    def rails
      "#{Rails.root}/bin/rails"
    end

    def python3
      '/usr/bin/python3 -u'
    end

    def local_command script_path
      extname = File.extname script_path

      case extname
      when '.rb'
        [rails, 'runner', script_path].join ' '
      when '.py'
        [python3, script_path].join ' '
      else
        system 'chmod', '+x', script_path

        script_path
      end
    end

    def local_exec script_path, executable
      status = 1
      errors = nil

      Open3.popen3 variables(executable), local_command(script_path) do |stdin, stdout, stderr, thread|
        executable.update! pid: thread.pid

        stdout.each { |line| yield "#{line.strip}\n" }

        errors = stderr.read
        status = thread.value.exitstatus.to_i
      end

      return status, errors
    end

    def remote_exec script_path, _executable = nil
      status  = 1
      stderr  = nil
      options = ssh_options options: { set_env: variables(_executable) }

      Net::SSH.start hostname, user, options do |ssh|
        # script permission
        ssh.exec! "chmod +x #{script_path}"

        status, stderr = ssh_exec ssh, "$SHELL -c #{script_path}" do |data|
          data.to_s.split("\n").each do |line|
            yield "#{line}\n"
          end
        end

        # Clean the script
        ssh.exec! "rm #{script_path}"
      end

      return status, stderr
    end

    def ssh_exec ssh, command
      status = 1
      stderr = []

      channel = ssh.open_channel do |och|
        # Command execution
        och.exec command do |ch, success|
          # STDOUT
          ch.on_data do |_ch, data|
            yield data.force_encoding 'UTF-8'
          end

          # STDERR
          ch.on_extended_data do |_ch, _type, data|
            stderr << data.force_encoding('UTF-8')
          end

          # Command status
          ch.on_request 'exit-status' do |_ch, data|
            status = data.read_long
          end
        end
      end

      # Wait until the command finish
      channel.wait

      return status, stderr.join
    end

    def variables executable
      executable.script.variables.each_with_object({}) do |variable, hash|
        hash[variable.name] = variable.value
      end if executable
    end
end
