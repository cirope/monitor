$(document).on('focus keydown click', 'input[data-date-picker]', function () {
  $(this)
    .datetimepicker({ locale: $('html').prop('lang') })
    .removeAttr('data-date-picker')
    .focus()
})
