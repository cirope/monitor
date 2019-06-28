+function () {
  var _onBeforeUnload = function (event) {
    var editor = $('.editor[data-observe-changes]')

    if (editor.data('unsavedData')) {
      if (event) event.returnValue = editor.data('unsavedDataWarning')

      return editor.data('unsavedDataWarning')
    }
  }

  if (window.addEventListener)
    window.addEventListener('beforeunload', _onBeforeUnload)
  else
    window.onbeforeunload = _onBeforeUnload

  $(document).on('change', '.editor[data-observe-changes]', function () {
    $('.editor[data-observe-changes]').data('unsavedData', true)
  })

  $(document).on('click', 'input[type=submit]', function () {
    $('.editor[data-observe-changes]').data('unsavedData', false)
  })

  $(document).on('turbolinks:before-visit', function (){
    var editor = $('.editor[data-observe-changes]')

    if (editor.data('unsavedData')) return confirm(editor.data('unsavedDataWarning'))
  })
}()
