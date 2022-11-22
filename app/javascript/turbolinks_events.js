$(document).on('turbo:submit-start', function () {
  $('.loading-caption').removeAttr('hidden')
})

$(document).on('turbo:submit-end', function () {
  $('.loading-caption').attr('hidden', true)
})

$(document).on('turbo:load', function () {
  var leftSidebar = new $.LeftSidebar.Constructor

  leftSidebar.init()
  $('[autofocus]').focus()
})
