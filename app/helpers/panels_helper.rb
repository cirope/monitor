# frozen_string_literal: true

module PanelsHelper
  def panel_col_class panel
    "col-md-#{panel.width * 4}"
  end

  def panel_height panel
    "col-mh-#{panel.height * 4}"
  end

  def panel_highlight panel
    if panel == @panel && (action_name == 'edit' || action_name == 'update')
      "panel-highlight"
    end
  end

  def queries
    @panel.queries.new if @panel.queries.empty?

    @panel.queries
  end

  def outputs
    Panel::OUTPUTS.map { |o| [t("panels.outputs.#{o}"), o] }
  end

  def frequencies
    Query::FREQUENCIES.map { |f| [t("queries.frequencies.#{f}"), f] }
  end

  def functions
    Query::FUNCTIONS.map { |f| [t("queries.functions.#{f}"), f] }
  end

  def periods
    Query::PERIODS.map { |c| [t("queries.periods.#{c}"), c] }
  end
end
