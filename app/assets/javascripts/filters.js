$(document).keydown(function (event) {
  if (event.which === 32 && event.ctrlKey) {
    event.stopPropagation()
    event.preventDefault()

    $('#filters').collapse('toggle')
  }
})

$(document).on('shown.bs.collapse', '#filters', function () {
  $(this).find('[autofocus]').focus()
})
