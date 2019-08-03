module Scripts::Export
  extend ActiveSupport::Concern

  def extra_exports
    requires.map(&:script)
  end
end
