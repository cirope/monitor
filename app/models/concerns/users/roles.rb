# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  included do
    belongs_to :role
    has_many :permissions, through: :role
  end

  def can? action, section
    permissions.find_by(section: section.to_s)&.send "permit_#{action}"
  end
end
