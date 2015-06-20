module ScriptsHelper
  def file_identifier
    @script.file.identifier || @script.file_identifier if @script.file?
  end
end
