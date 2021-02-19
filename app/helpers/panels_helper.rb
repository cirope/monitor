# frozen_string_literal: true

module PanelsHelper
  def panel_col_class panel
    "col-md-#{panel.width * 4}"
  end

  def panel_height panel
    "col-mh-#{panel.height * 5}"
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
    Query::OUTPUTS.map { |o| [t("queries.outputs.#{o}"), o] }
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

  def draw_graph panel
    if panel.queries.count == 1
      draw_query panel.queries.first
    else
      mixed_charts do
        panel.queries.each do |q|
          send "#{q.output}_chart", q.generate_data
        end
      end
    end
  end

  private

    def draw_query q
      send "#{q.output}_chart", q.generate_data
    end
end
