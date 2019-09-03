# frozen_string_literal: true

require 'test_helper'

class SystemProcessTest < ActiveSupport::TestCase

  test 'should get cpu percent use' do
    sleep_p = sleep_process interval: 0.4

    cpu_percent = sleep_p.cpu_percent(interval: 0.3)

    assert_not_nil cpu_percent
    # assert cpu_percent.positive? # sleep not consume much cpu...

    assert sleep_p.kill
  end

  test 'should get virtual memory' do
    sleep_p = sleep_process

    vmemory = sleep_p.virtual_memory

    assert_not_nil vmemory
    assert vmemory.positive?

    assert sleep_p.kill
  end

  test 'should get memory percent use' do
    sleep_p = sleep_process

    m_percent = sleep_p.memory_percent

    assert_not_nil m_percent
    # assert m_percent.positive? # sleep not consume much mem...

    assert sleep_p.kill
  end

  test 'should not be running after finish' do
    sleep_p = sleep_process

    assert sleep_p.still_running?
    sleep 0.2
    refute sleep_p.still_running?
  end

  test 'should get correct command' do
    sleep_p = sleep_process

    assert_match 'sleep', sleep_p.command

    assert sleep_p.kill
  end

  test 'should get process seconds alive' do
    sleep_p = sleep_process interval: 0.2

    sleep 0.1

    created_at = sleep_p.created_at

    assert created_at
    assert created_at > 0.01

    assert sleep_p.kill
  end

  test 'should get boot_time' do
    assert SystemProcess.boot_time.positive?
  end

  test 'should get processors count' do
    assert SystemProcess.processors.positive?
  end

  test 'should get virtual page size' do
    assert SystemProcess.vm_page_size.positive?
  end

  test 'should get clock ticks count' do
    assert SystemProcess.clock_ticks.positive?
  end

  test 'should get cpu current cycles' do
    cpu_cycles = SystemProcess.current_cpu_cycles

    assert cpu_cycles
    assert cpu_cycles.positive?
  end

  test 'should get total system memory' do
    mem_info = SystemProcess.memory_info

    assert mem_info.is_a? Hash

    assert_not_nil mem_info[:total]
    assert mem_info[:total] > 1_000_000 # 1Gb
  end

  private

    def sleep_process interval: 0.1
      detached_process command: "sleep #{interval}"
    end

    def detached_process command: ''
      pid         = spawn command
      cmd_process = SystemProcess.new pid

      Process.detach pid # not wait for main process finish

      cmd_process
    end
end
