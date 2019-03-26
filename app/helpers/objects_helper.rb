# frozen_string_literal: true

module ObjectsHelper
  def render_object parent, key
    path   = key.split '__/__'
    object = parent.data

    path.each do |index|
      object = object[object.is_a?(Hash) ? index : index.to_i]
    end

    _render parent, object
  end

  def link_or_show parent, key, object, id
    if object.is_a?(Hash) || object.is_a?(Array)
      key = [params[:key], key].compact.join '__/__'

      link_to [parent, key: key, container_id: id], data: { remote: true } do
        content_tag :span, nil, class: 'glyphicon glyphicon-search', title: t('.more')
      end
    else
      object || raw('&nbsp;')
    end
  end

  def can_be_graphed? object
    object.values.all? { |v| v.kind_of? Numeric }
  end

  def graph_container object
    content_tag :div, nil, class: 'ct-chart ct-golden-section', data: {
      graph:  object.object_id,
      labels: object.keys,
      series: object.values
    }
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
