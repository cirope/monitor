module Accounts::OnEach
  extend ActiveSupport::Concern

  module ClassMethods
    def on_each
      find_each do |account|
        account.switch { yield account }
      end
    end
  end
end
