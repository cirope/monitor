/* global Tour */

+function () {
  $(document).on('click', '[data-tour]', function (event) {
    event.preventDefault()
    event.stopPropagation()

    var $link        = $(this)
    var tourDefaults = {
      steps:    $link.data('tour'),
      template: $('[data-tour-template]').html()
    }

    if ($link.data('steps').length == 1) {
      tourDefaults.onShown = function () {
        $('.tour-navigation-buttons').hide()
      }
    }

    var tour = new Tour(tourDefaults)

    tour.init()
    tour.start(true) // true => force start
  })
}()
