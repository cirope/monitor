+function () {
  $(document).on('dynamic-item.added', '#triggers', function () {
    $(document).trigger('editors:start')
  })
}()
