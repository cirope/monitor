class Issue < ActiveRecord::Base
  include Auditable
  include Issues::Status
  include Issues::Validation

  belongs_to :run

  def to_s
    run.to_s
  end
end
