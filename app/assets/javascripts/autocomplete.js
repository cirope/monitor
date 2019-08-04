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

    Autocomplete.prototype._
    }

  jQuery(function ($) {
    var selector = 'input[data-autocomplete-url]:not([data-observed])'

    $(document).on('focus', selector, function () {
      new Autocomplete($(this))
    })
  })
}(jQuery)





+function ($) {
  $(document).on('change', 'input[data-autocomplete-url]', function() {
    input = $(this)
    if (/^\s*$/.test(input.val()))
      $(input.data('autocompleteTarget')).val('');
  })

  $(document).on('focus', 'input[data-autocomplete-url]:not([data-observed])', function() {
    var source = function (request, response) {
      var input = $(this)

      jQuery.ajax({
        url:      input.data('autocompleteUrl'),
        dataType: 'json',
        data:     { q: request.term },
        success:  function (data) {
          self._renderResponse(data, response)
        }
      })
    }

    var select = function (event, ui) {
      var input    = $(this)
      var selected = ui.item

      $(input.data('autocompleteTarget')).val(selected.item.id)
      input.val(selected.value)
      input.trigger({
        type:    'update.autocomplete',
        element: input,
        item:    selected.item
      })

      return false
    }


    input = $(this);

    input.autocomplete({
      type:      'get',
      minLength: element.data('autocompleteMinLength'),
      source: source
    })

    // return input.data('ui-autocomplete')._renderItem = function(ul, item){
    //   ul.addClass('typeahead dropdown-menu');
    //   return $('<li></li>').data('item.autocomplete', item).append(
    //     $('<a></a>').html(item.label)
    //   ).appendTo(ul);
    // };
}).attr('data-observed', true);
})(jQuery)

