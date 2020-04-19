# frozen_string_literal: true

module PanelsHelper
  def panel_col_class panel
    "col-md-#{panel.width * 4}"
  end

  def panel_height panel
    "col-mh-#{panel.height * 4}"
  end

  def panel_frequencies
    Panel::FREQUENCIES.map { |f| [t("panels.frequencies.#{f}"), f] }
  end

  def panel_functions
    Panel::FUNCTIONS.map { |f| [t("panels.functions.#{f}"), f] }
  end

  def panel_output_types
    Panel::OUTPUT_TYPES.map { |o| [t("panels.output_types.#{o}"), o] }
  end

  def panel_periods
    Panel::PERIODS.map { |c| [t("panels.periods.#{c}"), c] }
  end

  def panel_graph_for

  end

  def panel_highlight panel
    if panel == @panel && (action_name == 'edit' || action_name == 'update')
      "panel-highlight"
    end
  end
end
