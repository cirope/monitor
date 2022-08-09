module PreControls::Control
  extend ActiveSupport::Concern

  def control
    status = 'ok'

    output = begin
      RequestStore.store[:stdout] = stdout = StringIO.new

      eval code
    rescue => ex
      status = 'error'

      ex.message
    ensure
      RequestStore.store[:stdout] = nil
    end

    control_outputs.create! status: status, output: output
  end

  private

    def code
      <<-RUBY
        ApplicationRecord.transaction do
          #{callback}
          raise ActiveRecord::Rollback
        end

        stdout.string
      RUBY
    end
end
