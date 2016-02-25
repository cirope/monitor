module ObjectsHelper
  def render_object parent, key
    path   = key.split '/'
    object = parent.data

    path.each do |index|
      object = object[object.is_a?(Hash) ? index : index.to_i]
    end

    _render parent, object
  end

  def link_or_show parent, key, object, id
    if object.is_a?(Hash) || object.is_a?(Array)
      key = [params[:key], key].compact.join '/'

      link_to [parent, key: key, container_id: id], data: { remote: true } do
        content_tag :span, nil, class: 'glyphicon glyphicon-search', title: t('.more')
      end
    else
      object || raw('&nbsp;')
    end
  end

  private

    def _render parent, object
      if object.is_a? Hash
        render 'objects/table', parent: parent, object: object
      elsif columns = columns_for(object)
        render 'objects/grid', parent: parent, object: object, columns: columns
      else
        render 'objects/ul', parent: parent, object: object
      end
    end

    def columns_for object
      return unless object.all? { |item| item.is_a? Hash }

      object.map { |item| item.keys }.compact.flatten.uniq[0..5]
    end
end
