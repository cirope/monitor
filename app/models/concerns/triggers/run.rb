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
          $stdout = StringIO.new
          #{callback}
          $stdout.string
        rescue => ex
          ex.inspect
        ensure
          $stdout = STDOUT
        end
      RUBY
    end
end
