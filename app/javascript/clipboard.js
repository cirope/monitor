jQuery(function () {
  $(document).on('object.panel.added', function () {
    if(navigator.clipboard){
      $('[data-copy-target]').each(function() {
        $(this).removeAttr('disabled');
      })
    }
  })

  $(document).on('click', '[data-copy-target]', function () {
    var $target = $($(this).data('copyTarget'));
      navigator.clipboard.writeText($target.text());
  })
})
