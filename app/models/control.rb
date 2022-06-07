class Control < ApplicationRecord
  include Auditable
  include Controls::ControlAnswers
  include Controls::Relations
  include Controls::Validation
end
