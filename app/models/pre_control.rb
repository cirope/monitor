# frozen_string_literal: true

class PreControl < Control
  include Auditable
  include PreControls::Control
end
