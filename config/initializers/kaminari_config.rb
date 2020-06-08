# frozen_string_literal: true

Kaminari.configure do |config|
  config.default_per_page = 10
  config.window           = 3
  config.left             = 1
  config.right            = 1
end
