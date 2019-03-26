# frozen_string_literal: true

module Jobs::Cleanup
  extend ActiveSupport::Concern

  def cleanup
    all_destroyed = true

    self.class.transaction do
      runs.find_each do |run|
        destroyed = run.destroy

        all_destroyed &&= destroyed
      end
    end

    all_destroyed
  end
end
