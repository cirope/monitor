module Executions::Status
  extend ActiveSupport::Concern

  included do
    before_save :handle_status_change

    enum status: {
      success: 'success',
      pending: 'pending',
      running: 'running',
      killed:  'killed',
      error:   'error'
    }
  end

  def finished?
    success? || error? || killed?
  end

  private

    def handle_status_change
      if status_changed? && status_was == 'killed'
        self.status = status_was

        clear_attribute_changes %w(status)
      elsif status_changed? && finished?
        notify_new_status
      end
    end

    def notify_new_status
      order = if %w(success error).include?(status_was) && killed?
                lines_count.next.next # Since it was previously notified
              else
                lines_count.next
              end

      ExecutionChannel.send_line id, line:   nil,
                                     order:  order,
                                     status: status,
                                     pid:    pid
    end
end
