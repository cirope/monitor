module Killable
  extend ActiveSupport::Concern

  def kill
    send_kill 'TERM' if can_be_killed?
  end

  def force_kill
    send_kill 'KILL' if can_be_killed?
  end

  def can_be_killed?
    pid && running?
  end

  private

    def send_kill signal
      Process.kill signal, pid
      mark_as_killed

      true
    rescue Errno::ESRCH
      nil
    end

    def mark_as_killed
      Timeout.timeout 30 do
        loop do
          Process.kill 0, pid

          sleep 0.2
        end
      end
    rescue Errno::ESRCH
      reload.update! status: 'killed', ended_at: Time.zone.now
    rescue Timeout::Error
      nil
    end
end
