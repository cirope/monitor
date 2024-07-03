# frozen_string_literal: true

require 'test_helper'

class Scripts::MeasuresHelperTest < ActionView::TestCase
  include ObjectsHelper

  test 'measure types' do
    assert_respond_to measure_types, :each
  end

  test 'measurable name' do
    run = runs :ls_on_atahualpa

    assert_match Run.model_name.human, measurable_name(run)
  end

  test 'measurable path' do
    run       = runs :ls_on_atahualpa
    execution = executions :live_ls
    @script   = execution.script

    assert_equal run, measurable_path(run)
    assert_equal [@script, execution], measurable_path(execution)
  end

  test 'measures graph for' do
    measure = measures :live_ls_measure

    assert_match measure.cpu.to_s, measures_graph_for(Measure.all, :cpu)
  end
end
