module Libraries::Print
  extend ActiveSupport::Concern

  def print
    try "#{language}_print"
  end

  def ruby_print
    ["gem '#{name}'", options].reject(&:blank?).join ', '
  end

  def python_print
    ["#{name}", options].reject(&:blank?).join ', '
  end
end
