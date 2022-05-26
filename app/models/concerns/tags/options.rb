# frozen_string_literal: true

module Tags::Options
  extend ActiveSupport::Concern

  def kind_options
    options = {
      issue:  { final: :boolean, group: :boolean, category: :boolean },
      script: { export: :boolean, editable: :boolean },
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

  def group
    options&.fetch 'group', nil
  end
  alias_method :group?, :group

  def group= group
    assign_option 'group', group == true || group == '1'
  end

  def category
    options&.fetch 'category', nil
  end
  alias_method :category?, :category

  def category= category
    assign_option 'category', category == true || category == '1'
  end

  def export
    options&.fetch 'export', nil
  end
  alias_method :export?, :export

  def export= export
    assign_option 'export', export == true || export == '1'
  end

  def editable
    options&.fetch 'editable', nil
  end
  alias_method :editable?, :editable

  def editable= editable
    assign_option 'editable', editable == true || editable == '1'
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end
