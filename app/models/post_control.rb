# frozen_string_literal: true

class PostControl < Control
  include Auditable
  include PostControls::Control
end
