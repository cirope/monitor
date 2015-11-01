module RulesHelper
  def triggers
    @rule.triggers.new if @rule.triggers.empty?

    @rule.triggers
  end
end
