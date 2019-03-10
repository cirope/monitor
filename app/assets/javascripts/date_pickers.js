$(document).on('focus keydown click', 'input[data-date-picker]', function () {
  var $input = $(this)
  var format = $input.data('dateTime') ? 'L LT' : 'L'
  var locale = {
    format:      format,
    applyLabel:  $input.data('dateLocaleApply'),
    cancelLabel: $input.data('dateLocaleCancel')
  }
  var options = {
    locale:              locale,
    autoApply:           true,
    singleDatePicker:    !  $input.data('dateRange'),
    timePicker:          !! $input.data('dateTime'),
    timePicker24Hour:    true,
    timePickerIncrement: 5
  }

  $input.on('cancel.daterangepicker', function (event, picker) {
    $input.val('')
  })

  $input
    .daterangepicker(options)
    .removeAttr('data-date-picker')
    .focus()
})
