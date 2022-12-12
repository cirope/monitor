+function () {
  $(document).on('change', 'input[data-autocomplete-url]', function () {
    var $input = $(this)

    if (! $input.val().trim())
      $($input.data('autocompleteTarget')).val(undefined)
  })

  $(document).on('focus', 'input[data-autocomplete-url]:not([data-observed])', function () {
    var $input         = $(this)
    var $targetElement = $($input.data('autocompleteTarget'))

    var _renderItem = function (item) {
      item.label  = item.label || item.name

      return {
        label: item.label,
        value: item.label,
        item:  item
      }
    }

    var _renderResponse = function (data, response) {
      var items = []

      if (data.length) {
        jQuery.each(data, function (i, item) {
          items.push(_renderItem(item))
        })
      } else {
        items.push({
          label: $input.data('emptyResultLabel') || '---',
          value: '',
          item:  {}
        })
      }

      response(items)
    }

    var _selected = function (event, ui) {
      var selected = ui.item

      $targetElement.val(selected.item.id)
      $input.val(selected.value)
      $input.trigger({
        type:    'update.autocomplete',
        element: $input,
        item:    selected.item
      })

      return false
    }

    var _source = function (request, response) {
      jQuery.ajax({
        url:      $input.data('autocompleteUrl'),
        dataType: 'json',
        data:     { q: request.term },
        success:  function (data) {
          _renderResponse(data, response)
        }
      })
    }

    $input.autocomplete({
      type:      'get',
      minLength: $input.data('autocompleteMinLength'),
      source:    _source,
      select:    _selected
    })

    $input.attr('data-observed', true)
  })
}()
