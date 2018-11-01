module Runs::OutputParser
  extend ActiveSupport::Concern

  def parse_and_find_lines_with_error
    return {} unless error?

    errors = output_lines_with_error.each_with_object({}) do |(n, error), memo|
      uuid, values = original_script_from_error_line n, error

      if uuid
        memo[uuid] ||= []
        memo[uuid] << values
      end
    end

    scripts = Script.where uuid: errors.keys

    scripts.each_with_object({}) do |script, memo|
      memo[script] = errors[script.uuid]
    end
  end

  def still_valid?
    dates  = script.class.cores.distinct.pluck :updated_at
    dates += script.includes.pluck :updated_at

    dates << script.updated_at

    dates.all? { |d| d <= updated_at }
  end

  private

    def output_lines_with_error
      own_script_errors = /#{script.uuid}#{Regexp.escape script.extension}:(\d+):in(.*)/

      output.split("\n").map do |line|
        match, line_number, error = *line.match(own_script_errors)

        [line_number.to_i - 1 , error] if line_number && error
      end.compact
    end

    def original_script_from_error_line line_number, error
      @parsed_body ||= script.body.split "\n"

      n           = line_number
      delta       = 0
      script_uuid = nil

      until n.zero?
        n -= 1

        match, script_uuid = *@parsed_body[n].match(/ (#{UUID_REGEX}) /)

        if script_uuid
          delta = n
          n = 0
        end
      end

      [
        script_uuid,
        {
          error: [@parsed_body[line_number].strip, error].join(' =>  '),
          line:  (line_number - delta - 1)
        }
      ] if script_uuid.present?
    end
end
