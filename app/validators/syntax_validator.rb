# frozen_string_literal: true

class SyntaxValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    errors = has_syntax_errors? value.to_s

    record.errors.add attribute, :syntax, errors: errors if errors
  end

  private

    def has_syntax_errors? code
      RequestStore.store[:stderr] = stderr = StringIO.new

      RubyVM::InstructionSequence.compile code

      false
    rescue SyntaxError => ex
      ex.message.lines.concat([stderr.string]).join("\n")
    ensure
      RequestStore.store[:stderr] = STDERR
    end
end
