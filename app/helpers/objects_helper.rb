# frozen_string_literal: true

module ObjectsHelper
  def render_object parent, key
    path      = key.split '__/__'
    object    = parent.data
    container = nil

    path.each_with_index do |index, i|
      object    = object[object.is_a?(Hash) ? index : index.to_i]
      container = object if i == path.size - 2
    end

    _render parent, container, object
  end

  def link_or_show parent, key, object, id
    if object.is_a?(Hash) || object.is_a?(Array)
      key = [params[:key], key].compact.join '__/__'

      link_to [parent, key: key, container_id: id], data: { remote: true } do
        icon 'fas', 'search', title: t('.more')
      end
    else
      object || raw('&nbsp;')
    end
  end

  def can_be_graphed? object
    object.values.all? { |v| v.kind_of? Numeric }
  end

  def graph_container object
    options = {
      id:    "chart-#{object.object_id}",
      class: 'graph-container',
      data:  {
        graph:  object.object_id,
        labels: object.keys,
        series: object.values
      }
    }

    content_tag :div, nil, options
  end

  private

    def _render parent, container, object
      object, offset = maybe_convert container, object
      partial        = if object.is_a? Hash
                         'objects/table'
                       elsif columns = columns_for(object)
                         'objects/grid'
                       else
                         'objects/ul'
                       end

      render partial, parent:  parent,
                      object:  object,
                      columns: columns,
                      offset:  offset || 0
    end

    def maybe_convert container, object
      is_array           = object.kind_of? Array
      is_two_dimensional = is_array && object.all? { |item| item.is_a? Array }
      uniq_item_sizes    = is_two_dimensional && object.map(&:size).uniq

      if is_two_dimensional && uniq_item_sizes.size == 1
        headers = object.shift

        [object.map { |row| Hash[headers.zip row] }, 1]
      elsif is_array && (headers = container.kind_of?(Array) && container.first)
        headers.size == object.size ? Hash[headers.zip object] : object
      else
        object
      end
    end

    def columns_for object
      if object.all? { |item| item.is_a? Hash }
        object.map { |item| item.keys }.compact.flatten.uniq[0..5]
      end
    end
end
