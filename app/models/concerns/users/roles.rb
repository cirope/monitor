# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  included do
    belongs_to :role
    has_many :permissions, through: :role

    delegate :security?, :supervisor?, :author?, :manager?, :owner?,
      :guest?, to: :role
  end

  def can? action, controller_path
    if action
      controller = controller_path.to_s.split('/').map &:classify
      section    = set_section controller

      set_permissions.detect { |per| per.section == section }&.send action
    end
  end

  private

    def set_permissions
      @_permissions ||= permissions.to_a
    end

    def set_section sections
      case sections.length
      when 1
        c_name = sections.first

        Permission.sections.detect { |section| section == c_name } ||
          Permission::MENU.values.flatten.detect do |hsh|
            hsh[:controllers]&.include? c_name
          end&.fetch(:item)
      when 2
        Permission::MENU.values.flatten.detect do |hsh|
          hsh[:item] == sections.first && hsh[:controllers]&.include?(sections.last)
        end&.fetch :item
      end
    end
end
