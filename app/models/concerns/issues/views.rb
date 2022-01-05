# frozen_string_literal: true

module Issues::Views
  extend ActiveSupport::Concern

  included do
    has_many :views, dependent: :destroy
  end

  def view_by user
    views.where('views.user_id = ?', user.id).take
  end
end
