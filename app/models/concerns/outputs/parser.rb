# frozen_string_literal: true

module Outputs::Parser
  extend ActiveSupport::Concern

  def parse_and_find_lines_with_error
    return {} unless error?

    case script.language
    when 'ruby'
      parse_and_find_lines_with_error_in_ruby
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

    def parse_and_find_lines_with_error_in_ruby
      errors = {}

      output_lines_with_error.each do |n, error|
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

    def output_lines_with_error
      own_script_errors = /#{script.uuid}#{Regexp.escape script.extension}:(\d+):in(.*)/

      output.split("\n").map do |line|
        line_number, error = *line.match(own_script_errors)&.captures

        [line_number.to_i - 1 , error] if line_number && error
      end.compact
    end

    def original_script_from_error_line line_number, error
      @parsed_body ||= script.body(false, server).split "\n"

      n           = line_number
      delta       = 0
      script_uuid = nil

      until n.zero?
        n = n.pred

        script_uuid = @parsed_body[n]&.match(/ (#{UUID_REGEX}) /)&.captures&.first

        if script_uuid
          delta = n
          n = 0
        end
      end

      [
        script_uuid,
        {
          error: [@parsed_body[line_number]&.strip, error].join(' =>  '),
          line:  (line_number - delta - 1)
        }
      ] if script_uuid.present?
    end
end
