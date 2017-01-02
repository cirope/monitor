module Tags::Options
  extend ActiveSupport::Concern

  def kind_options
    options = {
      issue:  { final: :boolean },
      script: { export: :boolean },
      user:   {}
    }

    options[kind.to_sym]
  end

  def final
    options&.fetch 'final', nil
  end
  alias_method :final?, :final

  def final= final
    assign_option 'final', final == true || final == '1'
  end

  def export
    options&.fetch 'export', nil
  end
  alias_method :export?, :export

  def export= export
    assign_option 'export', export == true || export == '1'
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end
