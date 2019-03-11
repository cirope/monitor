# frozen_string_literal: true

class Property < ApplicationRecord
  include Properties::Validations
  include PublicAuditable

  belongs_to :database

  def to_s
    "#{key} -> #{value}"
  end

  def password?
    key =~ /pass|pwd/i
  end
end
