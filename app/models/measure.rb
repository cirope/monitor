# frozen_string_literal: true

class Measure < ApplicationRecord
  include Measures::Validation

  belongs_to :measurable, polymorphic: true
  has_one :script, through: :measurable

  def rounded_cpu
    cpu.round
  end

  def memory_in_megabytes
    (memory_in_bytes / 1_048_576.0).round
  end
end
