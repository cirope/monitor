module Issues::Tickets
  extend ActiveSupport::Concern

  OWNER_TYPES = {
    'Script': { ticket: true, icon: 'code' },
    'Rule':   { ticket: true, icon: 'code-branch' },
    'Run':    { ticket: false }
  }

  included do
    scope :tickets, -> { where "#{table_name}.owner_type IS NULL OR #{table_name}.owner_type != 'Run'" }
  end

  def ticket?
    owner_type.blank? || Issue.ticket_types.include?(owner_type)
  end

  def owner_icon
    Issue::OWNER_TYPES[owner_type.to_sym].fetch :icon
  end

  def nullify
    update_column :owner_id, nil if owner&.ticket_pending
  end

  module ClassMethods
    def availables type
      active.where owner_id: nil, owner_type: type
    end

    def ticket_types
      Issue::OWNER_TYPES.select { |k,v| v[:ticket] }.keys.map &:to_s
    end
  end
end
