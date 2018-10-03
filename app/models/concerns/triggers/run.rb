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
          [stdout.string, ex.inspect].reject(&:blank?).join("\n")
        end
      RUBY
    end
end
