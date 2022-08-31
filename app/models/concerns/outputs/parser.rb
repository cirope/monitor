# frozen_string_literal: true

module Outputs::Parser
  extend ActiveSupport::Concern

  def parse_and_find_lines_with_error
    return {} unless error?

    case script.language
    when 'python', 'ruby'
      parse_and_find_lines_with_error_in script.language
    when 'sql'
      parse_and_find_lines_with_error_in_sql
    else
      {}
    end
  end

  def still_valid?
    dates  = script.class.cores.distinct.pluck :updated_at
    dates += script.includes.pluck :updated_at

    dates << script.updated_at

    dates.all? { |d| d <= updated_at }
  end

  private

    def parse_and_find_lines_with_error_in_sql
      splitted_output = output.split "\n"

      db_errors = splitted_output.grep(/\A(PG|OCIError|TinyTds|SQLite3|Mysql2):/).uniq
      pg_errors = splitted_output.grep(/\ALINE \d+:/).uniq
      line      = nil

      pg_errors.each do |pg_line|
        line_number, error = pg_line.match(/\ALINE (\d+):(.*)\z/).captures

        db_errors << error
        line       = line_number
      end

      errors_with_lines = db_errors.map { |e| { error: e, line: line } }

      if errors_with_lines.any?
        { script => lined_errors }
      else
        {}
      end
    end

    def parse_and_find_lines_with_error_in language
      errors = {}
      own_script_errors = line_with_error_in language

      output_lines_with_error(own_script_errors).each do |n, error|
        uuid, values = original_script_from_error_line n, error

        if uuid
          errors[uuid] ||= []
          errors[uuid] << values
        end
      end

      scripts = Script.where uuid: errors.keys

      scripts.each_with_object({}) do |script, memo|
        memo[script] = errors[script.uuid]
      end
    end

    def output_lines_with_error own_script_errors
      output.split("\n").map do |line|
        line_number, error = *line.match(own_script_errors)&.captures

        [line_number.to_i - 1, error] if line_number && error
      end.compact
    end

    def original_script_from_error_line line_number, error
      script_tmp = parsed_text = nil

      @parsed_body ||= script.body(false, server).split "\n"

      line_with_error = @parsed_body[line_number]&.strip

      @parsed_body.each do |line|
        step, script_uuid = line.match(/ (\w+) (#{UUID_REGEX}) /i)&.captures

        if step && script_uuid
          case step.downcase
          when 'begin'
            if script_tmp = Script.find_by(uuid: script_uuid)
              parsed_text = script_tmp.text.split("\n").map &:strip
            end
          when 'end'
            script_tmp = parsed_text = nil
          end
        elsif script_tmp && parsed_text
          if line_index = parsed_text.index(line_with_error)
             return [
                script_tmp.uuid,
                {
                  error: [line_with_error, error].join(' =>  '),
                  line:  line_index + 1
                }
              ]
          end
        end
      end
    end

    def line_with_error_in language
      case language
      when 'ruby'
        /#{script.uuid}#{Regexp.escape script.extension}:(\d+):in(.*)/
      when 'python'
        /#{script.uuid}#{script.extension}", line (\d+), in(.*)/
      end
    end
end
