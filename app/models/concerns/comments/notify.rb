module Comments::Notify
  extend ActiveSupport::Concern

  included do
    after_commit :send_email, on: :create
  end

  private

    def send_email
      users = self.users - [self.user]

      Notifier.comment(self, users).deliver_later
    end
end
