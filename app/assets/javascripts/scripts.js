+function () {
  var editor = null

  jumpToLine = function(editor) {
    var params = (new URL(window.location)).searchParams;

    if (params.get('line')) {
      line = +params.get('line') - 1;

      editor.scrollIntoView({ line: line, ch: 0 }, 200);
      editor.setCursor({ line: line, ch: 0 });
      editor.focus();
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
          $change.closest('.form-group').removeClass('hidden')
          $file.prop('disabled', true).addClass('hidden')
        } else {
          $change.prop('disabled', true)
          $change.closest('.form-group').addClass('hidden')
          $file.prop('disabled', false).removeClass('hidden')
        }
      });

      jumpToLine(editor);
    }
  })

  $(document).on('change', '#script_file', function () {
    editor && editor.setOption('readOnly', $(this).val())
  })
}()
