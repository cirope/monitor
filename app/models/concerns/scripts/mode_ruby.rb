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
    libs = libraries.map do |library|
      "gem '#{library}', '#{library.options}'"
    end.join("\n")

    StringIO.new.tap do |buffer|
      buffer << <<-RUBY
        require 'bundler/inline'

        gemfile do
          source 'https://rubygems.org'

          #{libs}
        end\n
      RUBY
    end.string
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
      StringIO.new.tap do |buffer|
        buffer << <<-RUBY
          Account.find(#{Account.current.take.id}).switch!
          script_id = #{self.id}
        RUBY
      end.string
    end
end
