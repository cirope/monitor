+function () {
  var editor = null

  $(document).on('ready page:load', function () {
    if ($('.editor').length) {
      var $editor   = $('.editor')
      var $textarea = $('#script_text')
      var theme     = $editor.data('readonly') ? 'solarized_dark' : 'solarized_light'

      editor = ace.edit($editor.get(0))

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

        $('#script_file').prop('disabled', !!text.trim())
      })
    }
  })

  $(document).on('change', '#script_file', function () {
    editor && editor.setReadOnly($(this).val())
  })
}()
