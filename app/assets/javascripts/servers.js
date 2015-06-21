$(document).on('keyup', '#server_password', function () {
  var password = $(this).val()

  $('#server_credential').prop('disabled', !!password)
})
