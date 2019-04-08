# frozen_string_literal: true

module Comments::Notify
  extend ActiveSupport::Concern

  included do
    attr_writer :notify

    after_commit :send_email, on: :create, if: :notify
  end

  def notify
    @notify.nil? ? true : @notify
  end

  private

    def send_email
      users = self.users - [self.user]

      Notifier.comment(self, users).deliver_later
    end
end
