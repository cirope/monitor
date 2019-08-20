# frozen_string_literal: true

class FileRemoveJob < ApplicationJob
  queue_as :default

  def perform path
    rm path if File.exist? path
  end

  private

    def rm path
      Thread.new { sleep wait_time; FileUtils.rm path }
    end

    def wait_time
      ENV['TRAVIS'] ? 0.1 : 0.01
    end
end
