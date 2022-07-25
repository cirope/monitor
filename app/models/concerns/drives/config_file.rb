module Drives::ConfigFile
  extend ActiveSupport::Concern

  included do
    after_destroy :remove_section
  end

  def section
    name.parameterize(separator: '_')
  end

  private

    def remove_section
      system "rclone config delete #{section}"
    end
end
