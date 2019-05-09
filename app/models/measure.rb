class Measure < ApplicationRecord
  belongs_to :measureable, polymorphic: true

  def memory_in_b
    memory_in_kb * 1024 if memory_in_kb
  end

  def memory_in_mb
    (memory_in_kb / 1024.0).round if memory_in_kb
  end
end
