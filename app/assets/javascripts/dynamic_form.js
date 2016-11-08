+function () {
  var effects = {
    hide: function (element, callback) {
      $(element).stop().fadeOut(200, callback)
    },

    remove: function (element, callback) {
      $(element).stop().fadeOut(200, function () {
        $(this).remove()

        if (typeof callback === 'function') callback()
      })
    }
  }

  var helper = {
    idCounter: 0,

    replaceIds: function (s, regex) {
      return s.replace(regex, new Date().getTime() + helper.idCounter++)
    }
  }

  var events = {
    addNestedItem: function (e) {
      var template = e.data('dynamic-template')
      var regexp   = new RegExp(e.data('id'), 'g')

      e.before(helper.replaceIds(template, regexp))

      e.trigger('dynamic-item.added', e)
      // Add one new element of each (sub)nested element
      e.prev().find('[data-dynamic-form-event="addNestedItem"]').trigger('click')
    },

    hideItem: function (e) {
      effects.hide(e.closest('fieldset'))

      e.prev('input[type=hidden][data-destroy-field]').val('1').trigger('dynamic-item.hidden', e)
    },

    removeItem: function (e) {
      effects.remove(e.closest('fieldset'), function () {
        e.trigger('dynamic-item.removed', e)
      })
    }
  }

  jQuery(function ($) {
    var linkSelector = 'a[data-dynamic-form-event]'
    var eventList    = $.map(events, function (v, k) { return k })

    $(document).on('click', linkSelector, function (event) {
      if (event.stopped) return

      var eventName = $(this).data('dynamic-form-event')

      if ($.inArray(eventName, eventList) != -1) {
        events[eventName]($(this))

        event.preventDefault()
        event.stopPropagation()
      }
    })

    $(document).on('dynamic-item.added', linkSelector, function (event, element) {
      var selector = '[autofocus]:not([readonly]):enabled:visible:first, :input:enabled:visible:first'

      $(element).prev('fieldset').find(selector).focus()
    })
  })
}()
