# frozen_string_literal: true
module Scripts::ModeSql
  extend ActiveSupport::Concern

  def sql_headers _server
    global_settings
  end

  def sql_includes
    ['json', 'active_record', database.adapter_gems].flatten.map do |gem_name|
      "require '#{gem_name}'\n"
    end.join
  end

  def sql_commented_text comment = nil
    comment ||= 'script body'

    [
      "# Begin #{uuid} #{name} #{comment}",
      "#{text_with_sql_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join "\n\n"
  end

  def sql_db_connection
    ar_connection database
  end

  private

    def text_with_sql_injections
      <<-RUBY
        #{helper_functions}

        begin
          query   = %Q{#{text}}
          pool    = _ar_connection(#{database.ar_config}, '#{database.cipher_key}')
          results = pool.connection.exec_query(query).to_a

          puts wrap_results(query, results).to_json
        rescue ActiveRecord::StatementInvalid => e
          puts e.message

          exit 1
        end
      RUBY
    end

    def helper_functions
      <<-RUBY
        def wrap_results query, results
          metadata = extract_metadata query

          if metadata[:params]&.size > 0 || metadata[:results_key]
            results_key = metadata[:results_key] || 'results'

            Hash(metadata[:params]).merge results_key => results
          else
            results
          end
        end

        def extract_metadata query
          params = query.lines.each_with_object({}) do |line, metadata|
            if is_magic_comment? 'param', line
              metadata.merge! Hash(extract_magic_comment line)
            end
          end

          results_key = query.lines.map do |line|
            extract_magic_comment line if is_magic_comment? 'results_key', line
          end.compact.first

          { results_key: results_key, params: params }
        end

        def is_magic_comment? key, line
          line =~ /\\A\\s*--\\s*\#{key}:/
        end

        def extract_magic_comment line
          match        = line.match /\\A\\s*--\\s*(\\w+):\\s*(.*)\\s*\\z/
          _, key, text = *Array(match)

          JSON.parse text rescue nil
        end
      RUBY
    end
end
