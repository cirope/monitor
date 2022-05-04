# frozen_string_literal: true

require 'test_helper'

class PanelsHelperTest < ActionView::TestCase
  test 'panel col class' do
    panel    = panels :servers_overloaded
    expected = "col-md-#{panel.width * 4}"

    assert_match expected, panel_col_class(panel)
  end
end
