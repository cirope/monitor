# frozen_string_literal: true

class FileRemoveJob < ApplicationJob
  queue_as :default

  def perform path
    rm path if File.exist? path
  end

  private

    def rm path
      Thread.new { sleep 0.01; FileUtils.rm path }
    end
end
