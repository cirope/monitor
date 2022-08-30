module Scripts::ModePython
  extend ActiveSupport::Concern

  def python_headers _server
  end

  def python_dependencies
    includes.map do |script|
      script.body 'local inclusion'
    end.join
  end

  def python_commented_text comment = nil
    comment ||= 'script body'

    [
      "# Begin #{uuid} #{name} #{comment}",
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

  def language_variables
    StringIO.new.tap do |buffer|
      buffer << as_inner_varialble('parameters', parameters)
      buffer << as_inner_varialble('attributes', descriptions)
    end.string
  end

  private

    def as_inner_varialble name, collection
      result = "#{name} = {}\n\n"

      collection.each do |object|
        result += "#{name}['#{object.name}'] = '#{object.value}'\n"
      end

      "#{result}\n"
    end
end
