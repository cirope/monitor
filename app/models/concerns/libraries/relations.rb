module Libraries::Relations
  extend ActiveSupport::Concern

  included do
    belongs_to :script, inverse_of: :libraries

    delegate :language, to: :script, allow_nil: false
  end
end
