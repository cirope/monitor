$(document).on('change', '#drive_provider', function () {
  var providerOptionsUrl = $(this).find(':selected').attr('data-drive-provider-options-url');

  $.getScript(providerOptionsUrl);
})
