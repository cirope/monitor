module CommentsHelper
  def comment_file_identifier form
    object = form.object

    object.file.identifier || object.file_identifier if object.file?
  end
end
