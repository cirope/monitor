# frozen_string_literal: true

class MeasureJob < ApplicationJob
  queue_as :default

  def perform pid, measurable
    while File.directory?("/proc/#{pid}")
      cpu_time     = total_cpu_time
      process_time = process_time pid

      if @previous_cpu_time && @previous_process_time && cpu_time && process_time
        cpu = (process_time - @previous_process_time) /
              (cpu_time - @previous_cpu_time).to_f    *
              100.0

        measurable.measures.build cpu:             cpu,
                                  memory_in_bytes: process_memory(pid),
                                  created_at:      Time.zone.now
      end

      @previous_cpu_time     = cpu_time
      @previous_process_time = process_time

      sleep 2
    end

    measurable.save!
  end

  private

    def total_cpu_time
      times = File.readlines('/proc/stat').first.sub(/\Acpu\s+/, '').split
      time  = times.map(&:to_i).sum if times.present?

      time && (time / processors.to_f)
    end

    def process_time pid
      file = "/proc/#{pid}/stat"
      data = File.read(file).split if File.exists? file
      # 13 = utime / 14 = stime
      data = [data[13], data[14]].compact if data.present?

      data.map(&:to_i).sum if data.present?
    end

    def process_memory pid
      file = "/proc/#{pid}/stat"
      data = File.read(file).split if File.exists? file

      # 22 = vsize
      data[22].to_i if data.present?
    end

    def processors
      @_processors ||= File.readlines('/proc/cpuinfo').grep(/\Aprocessor/).size
    end
end
