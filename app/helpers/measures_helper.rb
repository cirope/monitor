module MeasuresHelper
  def measures_graph_for measures, method
    stats = measures.each_with_object({}) do |measure, memo|
      memo[l measure.created_at, format: :compact] = measure.send method
    end

    graph_container stats.sort.to_h, type: 'line', options: { height: '20%' }
  end
end
