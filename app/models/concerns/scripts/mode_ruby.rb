# frozen_string_literal: true
module Scripts::ModeRuby
  extend ActiveSupport::Concern

  def ruby_headers server
    [
      lang_libraries.to_s,
      global_settings,
      (local_context if server&.local?),
      add_cores_code
    ].compact.join
  end

  def ruby_libraries
    libs = libraries.to_a + included_libraries.to_a

    if libs.present?
      <<~RUBY
        require 'bundler/inline'

        gemfile do
          source 'https://rubygems.org'

          #{ruby_import_libs(libs)}
        end\n
      RUBY
    end
  end

  def ruby_includes
    includes.map do |script|
      script.body 'local inclusion'
    end.join
  end

  def ruby_commented_text comment = nil
    comment ||= 'script body'

    [
      "# Begin #{uuid} #{name} #{comment}",
      "#{text_with_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join("\n\n")
  end

  def ruby_db_connection
    ar_connection @db
  end

  private

    def local_context
      <<~RUBY
        Account.find(#{Account.current.take.id}).switch!
        script_id = #{self.id}\n
      RUBY
    end

    def ruby_import_libs libs
      libs.map { |library| library.print }.join "\n"
    end
end
