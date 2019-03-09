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

  def execution execution
    script_path = execution.script.copy_to self
    status      = 1

    Open3.popen2e rails, 'runner', script_path do |stdin, stdout, thread|
      stdout.each do |line|
        execution.new_line line
      end

      status = thread.value.exitstatus.to_i
    end

    if status.zero?
      :success
    else
      execution.new_line "Exit status: #{status}"
      :error
    end
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
      out = Net::SSH::Connection::Session::StringWithExitstatus.new '', 0

      Net::SSH.start hostname, user, ssh_options do |ssh|
        ssh.exec! "chmod +x #{script_path}"

        out = ssh.exec! "$SHELL -ci #{script_path}"

        ssh.exec! "rm #{script_path}"
      end

      status_text = "\nExit status: #{out.exitstatus}" unless out.exitstatus == 0

      {
        status: out.exitstatus == 0 ? 'ok' : 'error',
        output: out.to_s + status_text.to_s
      }
    end
end
