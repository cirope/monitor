$(document).on('ready page:load', function () {
  if ($('.editor').length) {
    var $editor   = $('.editor')
    var $textarea = $('#script_text')
    var editor    = ace.edit($editor.get(0))

    editor.setTheme('ace/theme/solarized_light')
    editor.getSession().setMode('ace/mode/ruby')

    editor.setValue($textarea.val())
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    editor.setReadOnly($editor.data('readonly'))
    editor.clearSelection()
    editor.gotoLine(0, 0)
    editor.setFontSize(14)

    editor.getSession().on('change', function () {
      $textarea.val(editor.getValue())
    })
  }
})
