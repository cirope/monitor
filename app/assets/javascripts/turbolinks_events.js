$(document).on('turbolinks:request-start', function () {
  $('.loading-caption').removeAttr('hidden')
})

$(document).on('turbolinks:request-end', function () {
  $('.loading-caption').attr('hidden', true)
})

$(document).on('turbolinks:load', function () {
  $('[autofocus]').focus()
})
