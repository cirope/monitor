# frozen_string_literal: true

class ExecutionChannel < ApplicationCable::Channel
  def subscribed
    stream_from_account "execution:#{execution.id}"
  end

  def fetch
    String(execution.stdout).lines.each_with_index do |line, i|
      self.class.send_line execution.id, line:     line,
                                         order:    i.next,
                                         status:   execution.status,
                                         pid:      execution.pid,
                                         finished: execution.finished?
    end
  end

  def self.send_line execution_id, line:, order:, status:, pid:, finished:
    broadcasting = broadcasting_for_current_account "execution:#{execution_id}"

    ActionCable.server.broadcast broadcasting, {
      line:     line,
      order:    order,
      status:   status,
      pid:      pid,
      finished: finished
    }
  end

  private

    def execution
      @execution ||= find_execution
    end

    def find_execution
      execution = nil

      current_account.switch do
        execution = ::Execution.find params[:id]
      end

      execution
    end
end
