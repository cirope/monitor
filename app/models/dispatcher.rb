class Dispatcher < ApplicationRecord
  include Auditable
  include Dispatchers::Validation

  belongs_to :schedule
  belongs_to :rule

  def to_s
    "#{schedule} -> #{rule}"
  end
end
