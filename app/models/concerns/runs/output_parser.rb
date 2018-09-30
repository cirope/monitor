module Runs::OutputParser
  extend ActiveSupport::Concern

  def parse_and_find_lines_with_error
    return {} unless error?

    scripts_with_error = {}

    output_lines_with_error.map do |line_number, error_msg|
      result = original_script_from_error_line(line_number, error_msg)

      next if result.nil?

      uuid, values = result

      scripts_with_error[uuid] ||= []
      scripts_with_error[uuid] << values
    end

    scripts = Script.where(uuid: scripts_with_error.keys.uniq)

    scripts.each_with_object({}) do |script, memo|
      memo[script] = scripts_with_error[script.uuid]
    end
  end

  private

    def output_lines_with_error
      own_script_errors = /#{script.uuid}#{Regexp.escape script.extension}:(\d+):in(.*)/

      output.split("\n").map do |line|
        _match, line_number, error = *line.match(own_script_errors)

        [line_number.to_i - 1 , error] if line_number && error
      end.compact
    end

    def original_script_from_error_line(line_number, error)
      @parsed_body ||= script.body.split("\n")

      script_uuid = nil
      n = line_number

      until script_uuid || n.zero?
        n -= 1

        # _match, script_uuid = *@parsed_body[n].match(/\A# Begin (#{UUID_REGEX}) /)
        _match, script_uuid = *@parsed_body[n].match(/ (#{UUID_REGEX}) /) # match old errors too
      end

      return if script_uuid.blank?

      [
        script_uuid,
        {
          error: [@parsed_body[line_number].strip, error].join(' =>  '),
          line:  (line_number - n - 1)  # Calculamos la linea real del script
        }
      ]
    end
end
