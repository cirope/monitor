module Scripts::ModePython
  extend ActiveSupport::Concern

  def python_headers _server
  end

  def python_dependencies
  end

  def python_commented_text comment = nil
    comment ||= 'script'

    [
      "# Begin #{uuid} #{name} #{comment}\n\n",
      "#{text_with_python_injections}",
      "# End #{uuid} #{name} #{comment}\n\n"
    ].join("\n\n")
  end

  def python_extension
    '.py'
  end

  def language_inclusion
    "#!/usr/bin/env python3\n\n"
  end

  private

    def text_with_python_injections
      <<-RUBY
try:

  #{text.indent(2)}

except Exception as e:
  print(e)

      RUBY
    end
end
