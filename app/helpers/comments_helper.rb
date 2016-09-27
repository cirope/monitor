module CommentsHelper
  def comment_file_identifier form
    object = form.object

    object.file.identifier || object.file_identifier if object.file?
  end

  def comment_form_options
    {
      data: {
        remote:     @comment.persisted? && request.xhr?,
        comment_id: @comment.id
      }
    }
  end
end
