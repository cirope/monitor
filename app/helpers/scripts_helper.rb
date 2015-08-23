module ScriptsHelper
  def requires
    @script.requires.new if @script.requires.empty?

    @script.requires
  end

  def taggings
    @script.taggings.new if @script.taggings.empty?

    @script.taggings
  end

  def file_identifier
    @script.file.identifier || @script.file_identifier if @script.file?
  end
end
