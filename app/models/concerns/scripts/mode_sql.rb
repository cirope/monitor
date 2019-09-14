# frozen_string_literal: true
module Scripts::ModeSql
  extend ActiveSupport::Concern

  def sql_headers _server
    global_settings
  end

  def sql_dependencies
    ['active_record', database.adapter_gems].flatten.map do |gem_name|
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

  private

    def text_with_sql_injections
      %{
        begin
          pool = ActiveRecord::Base.establish_connection #{database.ar_config}

          puts pool.connection.execute(%Q{#{text}}).to_json
        rescue ActiveRecord::StatementInvalid => e
          puts e.message

          exit 1
        end
      }
    end
end
