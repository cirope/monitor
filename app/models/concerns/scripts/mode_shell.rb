module Scripts::ModeShell
  extend ActiveSupport::Concern

  def shell_headers _server
    global_settings
  end

  def shell_dependencies
    ['open3'].map do |gem_name|
      "require '#{gem_name}'\n"
    end.join
  end

  def shell_commented_text comment = nil
    comment ||= 'shell script'

    [
      "# Begin #{uuid} #{name} #{comment}",
      "#{text_with_shell_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join("\n\n")
  end

  private

    def text_with_shell_injections
      <<-RUBY
        begin
          text = %Q{#{text}}

          Open3.popen2e text do |stdin, stdout, thread|
            puts stdout.read
          end
        rescue Exception => e
          puts e.message

          exit 1
        end
      RUBY
    end
end
