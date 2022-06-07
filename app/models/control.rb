class Control < ApplicationRecord
  include Controls::ControlAnswers
  include Controls::Relations
  include Controls::Validation
end
