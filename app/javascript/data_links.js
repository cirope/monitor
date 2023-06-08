jQuery(function () {
  $(document).on('click', '[data-href]', function () {
    window.location = $(this).data('href')
  })
})
