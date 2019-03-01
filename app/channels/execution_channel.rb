class ExecutionChannel < ApplicationCable::Channel
  def subscribed
    stream_from_account "execution_#{params[:id]}"
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
      @execution ||= ::Execution.find params[:id]
    end
end
