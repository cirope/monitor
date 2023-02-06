# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  included do
    belongs_to :role
    has_many :permissions, through: :role

    delegate :security?, :supervisor?, :author?, :manager?, :owner?, :guest?, to: :role
  end

  def can? action_name, path
    section = path.to_s.split('/').first.classify
    action  = set_action action_name


    puts "######## PA #########################"
    puts section
    puts "#################################"
    Permission.system.include?(section) ||
      set_permissions.detect { |per| per.section == section }&.send(action)
  end

  private

    def set_permissions
      @_permissions ||= permissions.to_a
    end

    def set_action action_name
      case action_name.to_s
        when 'index', 'show' then 'read'
        when 'new', 'create', 'edit', 'update' then 'edit'
        when 'destroy' then 'remove'
        else false
        end
    end
end
