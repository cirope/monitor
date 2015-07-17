module ScriptsHelper
  def requires
    @script.requires.new if @script.requires.empty?

    @script.requires
  end

  def file_identifier
    @script.file.identifier || @script.file_identifier if @script.file?
  end
end
