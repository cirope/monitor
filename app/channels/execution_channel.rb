class ExecutionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "execution_#{execution.id}"
  end

  def initial_output
    return if execution.output.blank?

    execution.output.split("\n").each do |line|
      self.class.send_line(execution.id, line)
    end
  end

  def self.send_line(execution_id, line, status: nil)
    ActionCable.server.broadcast(
      "execution_#{execution_id}",
      line: line,
      status: status
    )
  end

  def execution
    @execution ||= ::Execution.find(params[:id])
  end
end
