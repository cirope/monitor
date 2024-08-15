# frozen_string_literal: true

module Scripts::MeasuresHelper
  def measure_types
    {
      execution: Execution.model_name.human(count: 0),
      run:       Run.model_name.human(count: 0)
    }
  end

  def measurable_name measurable
    [
      measurable.class.model_name.human,
      l(measurable.created_at, format: :compact)
    ].join(' - ')
  end

  def measurable_path measurable
    if measurable.kind_of? Execution
      [@script, measurable]
    else
      measurable
    end
  end

  def measures_graph_for measures, method, format: :full
    stats = measures.each_with_object({}) do |measure, memo|
      memo[l measure.created_at, format: format] = measure.send method
    end

    graph_container stats.sort.to_h, type: 'line', height: 450
  end
end
