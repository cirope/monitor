$(document).keydown(function (event) {
  if (event.which === 32 && event.ctrlKey) {
    event.stopPropagation()
    event.preventDefault()

    $('#filters').collapse('toggle')
  }
})
