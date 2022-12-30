$(document).on('turbo:submit-start turbo:click', function () {
  $('.loading-caption').removeAttr('hidden')
})

$(document).on('turbo:submit-end', function () {
  $('.loading-caption').attr('hidden', true)
})

$(document).on('turbo:load', function () {
  $('[autofocus]').focus()
})
