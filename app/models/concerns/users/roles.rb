# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  included do
    belongs_to :role
    has_many :permissions, through: :role

    delegate :security?, :supervisor?, :author?, :manager?, :owner?, :guest?, to: :role
  end

  def can? action, section
    set_permissions.detect { |per| per.section == section.to_s }&.send action
  end

  private

    def set_permissions
      @_permissions ||= permissions.to_a
    end
end
