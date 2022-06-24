module PostControls::Control
  extend ActiveSupport::Concern

  def control survey_answer: nil, answer: nil
    question = answer.question if answer.present?
    survey   = survey_answer.survey if survey_answer.present?
    status   = 'ok'

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
        end

        stdout.string
      RUBY
    end
end
