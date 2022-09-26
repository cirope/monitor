module Libraries::GemLine
  extend ActiveSupport::Concern

  def gem_line
    ["gem '#{name}'", options].reject(&:blank?).join ', '
  end
end
