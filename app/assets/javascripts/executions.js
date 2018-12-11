$(document).on('ready turbolinks:load', function () {
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (! outputDiv.length)
    return

  var executionId = outputDiv.data('actioncable-watch-execution-id')

  App.cable.subscriptions.create(
    { channel: "ExecutionChannel", id: executionId },
    {
      connected: function () {
        this.perform('fetch')
        $('.loading-caption').removeClass('hidden')
      },
      received: function (data) {
        outputDiv.append(data.line + "\n")
        outputDiv[0].scrollIntoView(false)

        if (data.status === 'success' || data.status === 'error') {
          window.location.reload()
        }
      }
    }
  )
})
