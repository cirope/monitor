# frozen_string_literal: true

module Measurable
  extend ActiveSupport::Concern

  included do
    # TODO: if some day we test this, remove the condition =)
    before_save :schedule_measure, on: :update, unless: -> { Rails.env.test? }

    has_many :measures, as: :measurable, dependent: :destroy
  end

  private

    def schedule_measure
      if pid_changed? && pid
        tenant_name = Apartment::Tenant.current

        Thread.new { measure tenant_name }
      end
    end

    def measure tenant_name
      Apartment::Tenant.switch tenant_name do
        while File.directory? "/proc/#{pid}"
          @previous_cpu_cycles, @previous_process_cycles = *record_measure

          sleep 2
        end
      end
    end

    def record_measure
      cpu_cycles     = current_cpu_cycles
      process_cycles = current_process_cycles

      if valid_measure? cpu_cycles, process_cycles
        net_process_cycles = process_cycles - @previous_process_cycles
        net_cpu_cycles     = cpu_cycles     - @previous_cpu_cycles
        process_cpu        = (net_process_cycles / net_cpu_cycles.to_f) * 100.0

        measures.create! cpu: process_cpu, memory_in_bytes: process_memory
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

    def current_cpu_cycles
      data   = File.readlines('/proc/stat').first.sub(/\Acpu\s+/, '').split
      cycles = data.map(&:to_i).sum if data.present?

      cycles && (cycles / processors.to_f)
    end

    def current_process_cycles
      file = "/proc/#{pid}/stat"
      data = File.read(file).split if File.exists? file
      # 13 = utime / 14 = stime
      data = [data[13], data[14]].compact if data.present?

      data.map(&:to_i).sum if data.present?
    end

    def process_memory
      file = "/proc/#{pid}/stat"
      data = File.read(file).split if File.exists? file

      # 22 = vsize
      data[22].to_i if data.present?
    end

    def processors
      @_processors ||= File.readlines('/proc/cpuinfo').grep(/\Aprocessor/).size
    end
end
