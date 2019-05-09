module Measureable
  extend ActiveSupport::Concern

  included do
    has_many :measures, as: :measureable, dependent: :destroy
  end

  def with_measure &block
    GC::Profiler.enable
    GC::Profiler.clear

    result = nil

    bm_measure = Benchmark.measure do
      result = yield
    end

    GC.start full_mark: true, immediate_sweep: true

    profiler_data = GC::Profiler.raw_data

    memory = if (heap_size = profiler_data&.first&.fetch(:HEAP_TOTAL_SIZE, nil))
               (heap_size / 1024.0).round
             end

    cpu    = ((bm_measure.total / bm_measure.real) * 100).round 1

    measures.create cpu: cpu, memory_in_kb: memory

    GC::Profiler.disable

    result
  end
end
