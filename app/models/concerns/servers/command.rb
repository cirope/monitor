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

    if local?
      execute_local  run, script_path
    else
      execute_remote run, script_path
    end
  rescue => ex
    { status: 'error', output: ex.to_s }
  end

  def execution execution
    script_path = execution.script.copy_to self

    status = if local?
               local_execution execution, script_path
             else
               remote_execution execution, script_path
             end

    if execution.killed?
      'killed'
    elsif status.zero?
      'success'
    else
      execution.new_line "Exit status: #{status}"

      'error'
    end
  end

  private

    def rails
      "#{Rails.root}/bin/rails"
    end

    def execute_local run, script_path
      status      = ''
      exit_status = 1
      output      = StringIO.new

      Open3.popen2e rails, 'runner', script_path do |stdin, stdout, thread|
        run.update! pid: thread.pid

        stdout.each { |line| output << line }

        exit_status = thread.value.exitstatus.to_i
      end

      output << "\nExit status: #{exit_status}" unless exit_status.zero?

      status = if run.killed?
                 'killed'
               elsif exit_status.zero?
                 'ok'
               else
                 'error'
               end

      {
        status: status,
        output: output.string.presence
      }
    end

    def execute_remote run, script_path
      out = Net::SSH::Connection::Session::StringWithExitstatus.new '', 0

      Net::SSH.start hostname, user, ssh_options do |ssh|
        ssh.exec! "chmod +x #{script_path}"

        out = ssh.exec! "$SHELL -ci #{script_path}"

        ssh.exec! "rm #{script_path}"
      end

      status_text = "\nExit status: #{out.exitstatus}" unless out.exitstatus.zero?

      {
        status: out.exitstatus.zero? ? 'ok' : 'error',
        output: out.to_s + status_text.to_s
      }
    end

    def local_execution execution, script_path
      status = 1

      Open3.popen2e rails, 'runner', script_path do |stdin, stdout, thread|
        execution.update! pid: thread.pid

        stdout.each { |line| execution.new_line line }

        status = thread.value.exitstatus.to_i
      end

      status
    end

    def remote_execution execution, script_path
      status = 1

      Net::SSH.start hostname, user, ssh_options  do |ssh|
        # execution permission
        ssh.exec! "chmod +x #{script_path}"

        output_proc = -> (data) { execution.new_line data }

        status = ssh_exec_with_realtime_output ssh, "$SHELL -c #{script_path}", output_proc

        # Clean the script
        ssh.exec! "rm #{script_path}"
      end

      status
    end

    def ssh_exec_with_realtime_output ssh, command, output_proc
      status = 1

      channel = ssh.open_channel do |och|
        # Realtime log output
        och.request_pty

        # Command execution
        och.exec command do |ch, success|
          # STDOUT
          ch.on_data do |_ch, data|
            output_proc[data]
          end

          # STDERR
          ch.on_extended_data do |_ch, _type, data|
            output_proc.call data
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
