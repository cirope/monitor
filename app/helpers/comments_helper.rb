# frozen_string_literal: true

module CommentsHelper
  def comment_file_identifier form
    object = form.object

    object.attachment.filename.basename if object.attachment.attached?
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
