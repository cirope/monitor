+function () {
  var startEditors = function () {
    $('[data-editor]').each(function (i, element) {
      var $textarea = $(element)
      var readonly  = $textarea.data('readonly')
      var options   = {
        mode:              'ruby',
        tabSize:           2,
        autoCloseBrackets: true,
        matchBrackets:     true,
        lineNumbers:       true,
        styleActiveLine:   true,
        foldGutter:        true,
        theme:             readonly ? 'solarized dark' :  'solarized light',
        readOnly:          readonly,
        gutters:           ['CodeMirror-linenumbers', 'CodeMirror-foldgutter'],
        phrases:           $textarea.data('phrases')
      }

      CodeMirror.fromTextArea($textarea.get(0), options)

      $textarea.removeAttr('data-editor')
    })
  }

  $(document).on('ready turbolinks:load', startEditors)
  $(document).on('dynamic-item.added', '#triggers', startEditors)
}()
