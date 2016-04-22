module Tags::Options
  extend ActiveSupport::Concern

  def kind_options
    kind === 'issue' ? { final: :boolean } : {}
  end

  def final
    options&.fetch 'final', nil
  end
  alias_method :final?, :final

  def final= final
    assign_option 'final', final == true || final == '1'
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end
