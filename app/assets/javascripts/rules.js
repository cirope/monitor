var startEditors = function () {
  $('[data-editor]').each(function (i, element) {
    var $textarea = $(element)
    var editorId  = $textarea.prop('id') + '_editor'

    $textarea.after('<div id="' + editorId + '" class="tiny-editor"></div>')
    $textarea.val($textarea.val().trim())

    var $editor = $('#' + editorId)
    var editor  = ace.edit($editor.get(0))
    var theme   = $textarea.data('readonly') ? 'solarized_dark' : 'solarized_light'

    console.log($textarea.data('readonly'))
    editor.setTheme('ace/theme/' + theme)
    editor.getSession().setMode('ace/mode/ruby')

    editor.setValue($textarea.val())
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    editor.setReadOnly($textarea.data('readonly'))
    editor.clearSelection()
    editor.gotoLine(0, 0)
    editor.setFontSize(14)

    editor.getSession().on('change', function () {
      $textarea.val(editor.getValue())
    })

    $textarea.removeAttr('data-editor')
  })
}

$(document).on('ready page:load', startEditors)
$(document).on('dynamic-item.added', '#triggers', startEditors)
