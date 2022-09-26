# frozen_string_literal: true
module Scripts::ModeRuby
  extend ActiveSupport::Concern

  def ruby_headers server
    [
      lang_libraries.to_s,
      global_settings,
      (local_context if server&.local?),
      ruby_cores_code
    ].compact.join
  end

  def ruby_libraries
    <<~RUBY
      require 'bundler/inline'

      gemfile do
        source 'https://rubygems.org'

        #{ruby_libs}
      end\n
    RUBY
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

  private

    def ruby_cores_code
      StringIO.new.tap do |buffer|
        self.class.cores.where.not(id: id).distinct.each do |script|
          buffer << script.body('core inclusion')
        end
      end.string
    end

    def local_context
      <<~RUBY
        Account.find(#{Account.current.take.id}).switch!
        script_id = #{self.id}\n
      RUBY
    end

    def ruby_libs
      libs = libraries.to_a + includes_libraries.to_a

      libs.map { |library| library.gem_line }.join "\n"
    end
end
