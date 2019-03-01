class ExecutionChannel < ApplicationCable::Channel
  def subscribed
    stream_from_account "execution_#{execution.id}"
  end

  def fetch
    return if execution.output.blank?

    execution.output.split(/\r?\n/).each do |line|
      self.class.send_line execution.id, "#{line}\r\n"
    end
  end

  def self.send_line execution_id, line, status: nil
    broadcasting = broadcasting_for_current_account "execution_#{execution_id}"

    ActionCable.server.broadcast broadcasting, line: line, status: status
  end

  private

    def execution
      @execution ||= find_execution
    end

    def find_execution
      execution = nil

      current_account.switch { execution = ::Execution.find params[:id] }

      execution
    end
end
