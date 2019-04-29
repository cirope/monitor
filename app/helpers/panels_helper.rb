# frozen_string_literal: true

module PanelsHelper
  def panel_col_class panel
    "col-md-#{panel.width * 4}"
  end
end
