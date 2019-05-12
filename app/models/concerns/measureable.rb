module Measureable
  extend ActiveSupport::Concern

  included do
    has_many :measures, as: :measureable, dependent: :destroy
  end

  def with_measure &block
    GC::Profiler.enable
    GC::Profiler.clear

    result     = nil
    bm_measure = Benchmark.measure { result = yield }

    GC.start full_mark: true, immediate_sweep: true

    profiler_data = GC::Profiler.raw_data
    heap_size     = profiler_data&.first&.fetch :HEAP_TOTAL_SIZE, nil

    memory = (heap_size / 1024.0).round if heap_size
    cpu    = ((bm_measure.total / bm_measure.real) * 100).round 1

    measures.create cpu: cpu, memory_in_kb: memory

    GC::Profiler.disable

    result
  end
end
