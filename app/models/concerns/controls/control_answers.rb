module Controls::ControlAnswers
  extend ActiveSupport::Concern

  def control_answer answer
    question = answer.question
    status = 'ok'

    output = begin
      eval(code)
    rescue => ex
      status = 'error'
      ex.message
    end

    control_outputs.create! status: status, output: output
  end

  private

    def code
      <<-RUBY
        RequestStore.store[:stdout] = stdout = StringIO.new

        ApplicationRecord.transaction do
          #{callback}
        end

        stdout.string
      RUBY
    end
end
