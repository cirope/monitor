/* global CodeMirror */
/* eslint-disable no-alert */

+function () {
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

  var jumpToLine = function (editor, $textarea) {
    var params = urlQueryParams()

    if (params['line']) {
      var line = +params['line'] - 1

      if (params['model_id'] && params['model_id'] != $textarea.data('modelId')) {
        return
      }

      editor.scrollIntoView({ line: line, ch: 0 }, 200)
      editor.setCursor({ line: line, ch: 0 })
      editor.focus()
    }
  }

  var startEditors = function () {
    $('[data-editor]:not([data-observed])').each(function (i, element) {
      var $textarea = $(element)
      var $file     = $($textarea.data('fileInput'))
      var $change   = $($textarea.data('changeInput'))
      var readonly  = $textarea.data('readonly')
      var editor    = CodeMirror.fromTextArea($textarea.get(0), {
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
      })

      editor.on('change', function () { $textarea.trigger('change') })

      if ($change.length && $file.length) {
        $(document).on('change', $textarea.data('fileInput'), function () {
          editor && editor.setOption('readOnly', $(this).val())
        })

        editor.on('change', function () {
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
        })
      }

      jumpToLine(editor, $textarea)

      $textarea.attr('data-observed', true)
    })
  }

  var _onBeforeUnload = function (event) {
    var editor = $('[data-editor]')

    if (editor.data('unsavedData')) {
      if (event) event.returnValue = editor.data('unsavedDataWarning')

      return editor.data('unsavedDataWarning')
    }
  }

  // Events
  if (window.addEventListener)
    window.addEventListener('beforeunload', _onBeforeUnload)
  else
    window.onbeforeunload = _onBeforeUnload

  $(document).on('ready turbolinks:load editors:start', startEditors)

  $(document).on('change', '[data-editor]', function () {
    $('[data-editor]').data('unsavedData', true)
  })

  $(document).on('click', 'input[type=submit]', function () {
    $('[data-editor]').data('unsavedData', false)
  })

  $(document).on('turbolinks:before-visit', function () {
    var editor = $('[data-editor]')

    if (editor.data('unsavedData')) return confirm(editor.data('unsavedDataWarning'))
  })
}()
