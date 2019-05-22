+function () {
  var editor = null

  var urlQueryParams = function () {
    var params     = {}
    var paramsList = (location.search || '').substr(1).split('&')

    for (var i = 0; i < paramsList.length; ++i) {
      // :pray: for the Uganda children
      var param = paramsList[i].split('=', 2)

      if (param.length == 2)
        params[param[0]] = decodeURIComponent(param[1].replace(/\+/g, ' '))
    }

    return params
  }

  var jumpToLine = function (editor) {
    var params = urlQueryParams()

    if (params['line']) {
      line = +params['line'] - 1

      editor.scrollIntoView({ line: line, ch: 0 }, 200)
      editor.setCursor({ line: line, ch: 0 })
      editor.focus()
    }
  };

  $(document).on('ready turbolinks:load', function () {
    if ($('#script_text').length) {
      var $textarea = $('#script_text')
      var $file     = $('#script_file')
      var $change   = $('#script_change')
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

      editor = CodeMirror.fromTextArea($textarea.get(0), options)

      editor.on('change', function (editor) {
        var text = editor.getValue()

        if (text.trim()) {
          $change.prop('disabled', false).val('')
          $change.closest('.form-group').removeAttr('hidden')
          $file.prop('disabled', true).attr('hidden', true)
        } else {
          $change.prop('disabled', true)
          $change.closest('.form-group').attr('hidden', true)
          $file.prop('disabled', false).removeAttr('hidden')
        }

        $textarea.trigger('change')
      })

      jumpToLine(editor)
    }
  })

  $(document).on('change', '#script_file', function () {
    editor && editor.setOption('readOnly', $(this).val())
  })
}()
