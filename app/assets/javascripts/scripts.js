+function () {
  var editor = null

  $(document).on('ready turbolinks:load', function () {
    if ($('.editor').length) {
      var $editor   = $('.editor')
      var $textarea = $('#script_text')
      var $file     = $('#script_file')
      var $change   = $('#script_change')
      var theme     = $editor.data('readonly') ? 'solarized_dark' : 'solarized_light'

      editor = ace.edit($editor.get(0))

      editor.$blockScrolling = Infinity

      editor.setTheme('ace/theme/' + theme)
      editor.getSession().setMode('ace/mode/ruby')

      editor.setValue($textarea.val())
      editor.getSession().setTabSize(2)
      editor.getSession().setUseSoftTabs(true)
      editor.setReadOnly($editor.data('readonly'))
      editor.clearSelection()
      editor.gotoLine(0, 0)
      editor.setFontSize(14)

      editor.getSession().on('change', function () {
        var text = editor.getValue()

        $textarea.val(text)

        if (text.trim()) {
          $change.prop('disabled', false).val('')
          $change.closest('.form-group').removeClass('hidden')
          $file.prop('disabled', true).addClass('hidden')
        } else {
          $change.prop('disabled', true)
          $change.closest('.form-group').addClass('hidden')
          $file.prop('disabled', false).removeClass('hidden')
        }
      })
    }
  })

  $(document).on('change', '#script_file', function () {
    editor && editor.setReadOnly($(this).val())
  })
}()
