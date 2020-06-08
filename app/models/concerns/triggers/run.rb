# frozen_string_literal: true

module Triggers::Run
  extend ActiveSupport::Concern

  included do
    has_many :outputs, dependent: :destroy
  end

  def run_on run
    outputs.create! run: run, text: eval(code)
  end

  private

    def code
      <<-RUBY
        begin
          RequestStore.store[:stdout] = stdout = StringIO.new

          ApplicationRecord.transaction do
            #{callback}
          end

          stdout.string
        rescue => ex
          error  = [stdout.string, ex.message]
          error += app_lines_from_exception ex

          error.reject(&:blank?).join "\n"
        end
      RUBY
    end

    def app_lines_from_exception ex
      ex.backtrace.select do |line|
        line.start_with?('(eval):') || line.start_with?(Rails.root.to_s)
      end
    end
end
