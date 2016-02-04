module RulesHelper
  def triggers
    @rule.triggers.new if @rule.triggers.empty?

    @rule.triggers
  end

  def last_output trigger
    trigger.outputs.last&.text
  end
end
