+function ($) {
  var Autocomplete = (function () {
    function Autocomplete (element) {
      var self = this

      self.element       = element
      self.targetElement = $(element.data('autocompleteTarget'))

      self.init()
    }

    Autocomplete.prototype.init = function () {
      var self = this

      self.element.autocomplete({
        type:      'get',
        minLength: self.element.data('autocompleteMinLength'),
        source:    self._source.bind(self),
        select:    self._selected.bind(self)
      })

      self._markAsObserved()
      self._listenChanges()
    }

    Autocomplete.prototype._markAsObserved = function () {
      this.element.attr('data-observed', true)
    }

    Autocomplete.prototype._listenChanges = function () {
      var self = this

      self.element.change(function () {
        if (! self.element.val().trim())
          self.targetElement.val(undefined)
      })
    }

    Autocomplete.prototype._renderItem = function (item) {
      item.label  = item.label || item.name

      return {
        label: item.label,
        value: item.label,
        item:  item
      }
    }

    Autocomplete.prototype._renderResponse = function (data, response) {
      var self  = this
      var items = []

      if (data.length) {
        jQuery.each(data, function (i, item) {
          items.push(self._renderItem(item))
        })
      } else {
        items.push({
          label: self.element.data('emptyResultLabel') || '---',
          value: '',
          item:  {}
        })
      }

      response(items)
    }

    Autocomplete.prototype._selected = function (event, ui) {
      var self     = this
      var selected = ui.item

      self.targetElement.val(selected.item.id)
      self.element.val(selected.value)
      self.element.trigger({
        type:    'update.autocomplete',
        element: self.element,
        item:    selected.item
      })

      return false
    }

    Autocomplete.prototype._source = function (request, response) {
      var self = this

      jQuery.ajax({
        url:      self.element.data('autocompleteUrl'),
        dataType: 'json',
        data:     { q: request.term },
        success:  function (data) {
          self._renderResponse(data, response)
        }
      })
    }

    return Autocomplete
  })()

  jQuery(function ($) {
    var selector = 'input[data-autocomplete-url]:not([data-observed])'

    $(document).on('focus', selector, function () {
      new Autocomplete($(this))
    })
  })
}(jQuery)
