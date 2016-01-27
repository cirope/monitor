module Issues::Scopes
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where.not status: 'closed' }
  end

  module ClassMethods
    def script_scoped script
      joins(:script).where scripts: { id: script.id }
    end
  end
end
