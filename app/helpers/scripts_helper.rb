module ScriptsHelper
  def requires
    @script.requires.new if @script.requires.empty?

    @script.requires
  end

  def script_taggings
    @script.taggings.new if @script.taggings.empty?

    @script.taggings
  end

  def file_identifier
    @script.file.identifier || @script.file_identifier if @script.file?
  end

  def descriptions
    if @script.descriptions.empty?
      Descriptor.all.each { |d| @script.descriptions.new name: d.name }
    end

    @script.descriptions
  end
end
