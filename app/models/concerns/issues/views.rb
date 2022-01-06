# frozen_string_literal: true

module Issues::Views
  extend ActiveSupport::Concern

  included do
    has_many :views, dependent: :destroy
  end

  def view_by user
    views.find_by(user_id: user.id)
  end
end
