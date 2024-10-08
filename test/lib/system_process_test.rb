# frozen_string_literal: true

require 'test_helper'

class SystemProcessTest < ActiveSupport::TestCase

  test 'should get cpu percent use' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p     = sleep_process interval: 0.08
    cpu_percent = sleep_p.cpu_percent interval: 0.05

    assert_not_nil cpu_percent
    # assert cpu_percent.positive? # sleep not consume much cpu...

    assert sleep_p.kill
  end

  test 'should get virtual memory' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p = sleep_process
    vmemory = sleep_p.virtual_memory

    assert_not_nil vmemory
    assert vmemory.positive?

    assert sleep_p.kill
  end

  test 'should get memory percent use' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p   = sleep_process
    m_percent = sleep_p.memory_percent

    assert_not_nil m_percent
    # assert m_percent.positive? # sleep not consume much mem...

    assert sleep_p.kill
  end

  test 'should not be running after finish' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p = sleep_process

    assert sleep_p.still_running?
    sleep ENV['GH_ACTIONS'] ? 0.40 : 0.02
    refute sleep_p.still_running?
  end

  test 'should get correct command' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p = sleep_process

    assert_match 'sleep', sleep_p.command

    assert sleep_p.kill
  end

  test 'should get process seconds alive' do
    skip if RUBY_PLATFORM.include?('darwin')

    sleep_p = sleep_process interval: 0.03

    sleep 0.02

    created_at = sleep_p.created_at

    assert created_at
    assert created_at > 0.01

    assert sleep_p.kill
  end

  test 'should get boot_time' do
    skip if RUBY_PLATFORM.include?('darwin')

    assert SystemProcess.boot_time.positive?
  end

  test 'should get processors count' do
    skip if RUBY_PLATFORM.include?('darwin')

    assert SystemProcess.processors.positive?
  end

  test 'should get virtual page size' do
    skip if RUBY_PLATFORM.include?('darwin')

    assert SystemProcess.vm_page_size.positive?
  end

  test 'should get clock ticks count' do
    skip if RUBY_PLATFORM.include?('darwin')

    assert SystemProcess.clock_ticks.positive?
  end

  test 'should get cpu current cycles' do
    skip if RUBY_PLATFORM.include?('darwin')

    cpu_cycles = SystemProcess.current_cpu_cycles

    assert cpu_cycles
    assert cpu_cycles.positive?
  end

  test 'should get total system memory' do
    skip if RUBY_PLATFORM.include?('darwin')

    mem_info = SystemProcess.memory_info

    assert mem_info.is_a? Hash

    assert_not_nil mem_info[:total]
    assert mem_info[:total] > 1_000_000 # 1Gb
  end

  private

    def sleep_process interval: 0.01
      interval *= 20 if ENV['GH_ACTIONS']

      detached_process command: "sleep #{interval}"
    end

    def detached_process command: ''
      pid         = spawn command
      cmd_process = SystemProcess.new pid

      Process.detach pid # not wait for main process finish

      cmd_process
    end
end
