class SyntaxValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    errors = has_syntax_errors? value.to_s

    record.errors.add attribute, :syntax, errors: errors if errors
  end

  private

    def has_syntax_errors? code
      RubyVM::InstructionSequence.compile code

      false
    rescue SyntaxError => ex
      ex.message.lines.first.chomp
    end
end
