# frozen_string_literal: true

module Issues::Reminders
  extend ActiveSupport::Concern

  included do
    has_many :reminders, dependent: :destroy
  end
end
