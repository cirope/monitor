# frozen_string_literal: true

module Measurable
  extend ActiveSupport::Concern

  included do
    # TODO: if some day we test this, remove the condition =)
    before_save :schedule_measure, on: :update

    has_many :measures, as: :measurable, dependent: :destroy
  end

  private

    def schedule_measure
      if pid_changed? && pid
        tenant_name = Apartment::Tenant.current

        if Rails.env.test?
          measure # Needs to be online for testing
        else
          Thread.new do
            Apartment::Tenant.switch(tenant_name) { measure }
          end
        end
      end
    end

    def measure
      while File.directory? "/proc/#{pid}"
        @previous_cpu_cycles, @previous_process_cycles = *record_measure

        sleep 2
      end
    end

    def record_measure
      process = SystemProcess.new pid

      cpu_cycles, process_cycles = *process.cpu_and_proc_cycles

      if valid_measure? cpu_cycles, process_cycles
        net_process_cycles = process_cycles - @previous_process_cycles
        net_cpu_cycles     = cpu_cycles     - @previous_cpu_cycles
        process_cpu        = (net_process_cycles / net_cpu_cycles.to_f) * 100.0

        measures.create! cpu: process_cpu, memory_in_bytes: process.virtual_memory
      end

      [cpu_cycles, process_cycles]
    end

    def valid_measure? cpu_cycles, process_cycles
      @previous_cpu_cycles                &&
        @previous_process_cycles          &&
        cpu_cycles                        &&
        process_cycles                    &&
        cpu_cycles > @previous_cpu_cycles
    end
end
