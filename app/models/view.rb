# frozen_string_literal: true

class View < ApplicationRecord
  belongs_to :issue
  belongs_to :user
end
