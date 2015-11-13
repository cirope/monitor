module ObjectsHelper
  def render_object parent, key
    path   = key.split '/'
    object = parent.data

    path.each do |index|
      object = object[object.is_a?(Hash) ? index : index.to_i]
    end

    if object.is_a? Hash
      render 'objects/table', parent: parent, object: object
    else
      render 'objects/ul', parent: parent, object: object
    end
  end

  def link_or_show parent, key, object, id
    if object.is_a?(Hash) || object.is_a?(Array)
      key = [params[:key], key].compact.join '/'

      link_to t('.more'), [parent, key: key, container_id: id], data: { remote: true }
    else
      object
    end
  end
end
