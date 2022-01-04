# frozen_string_literal: true

class View < ApplicationRecord
  belongs_to :comment
  belongs_to :user
end
