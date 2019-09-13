+function () {
  var showHelpModal = function (help) {
    var $modal = $('#modal-help')

    $modal.find('.modal-title').html(help.title)
    $modal.find('.modal-body').html(help.content)

    $modal.modal()
  }

  var showHelpPopover = function (ref, help) {
    if (! ref.data('popoverInitialized')) {
      ref.popover({
        title:     help.title,
        content:   help.content,
        placement: help.placement || ref.data('placement') || 'right',
        html:      true,
        sanitize:  false,
        trigger:   'manual' // fix double click to clouse
      })

      ref.data('popoverInitialized', true)
    }

    ref.popover('toggle')
  }

  $(document).on('click', '[data-help]', function (event) {
    event.preventDefault()
    event.stopPropagation()

    var $link      = $(this)
    var help       = $link.data('help')
    var usePopover = (
      $link.data('popoverInitialized') ||
      help.use === 'popover' ||
      $(help.content).text().length <= 300 // $().text() sanitize html tags
    )

    if (usePopover)
      showHelpPopover($link, help)
    else
      showHelpModal(help)
  })
}()
