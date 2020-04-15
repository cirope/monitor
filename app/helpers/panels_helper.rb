# frozen_string_literal: true

module PanelsHelper
  def panel_col_class panel
    "col-md-#{panel.width * 4}"
  end

  def panel_functions
    Panel::FUNCTIONS.map { |f| [t("panels.functions.#{f}"), f] }
  end

  def panel_output_types
    Panel::OUTPUT_TYPES.map { |o| [t("panels.output_types.#{o}"), o] }
  end
end
