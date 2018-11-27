$(document).on('ready turbolinks:load', function () {
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (! outputDiv.length)
    return

  var executionId = outputDiv.data('actioncable-watch-execution-id')

  App.cable.subscriptions.create(
    { channel: "ExecutionChannel", id: executionId },
    {
      connected: function () {
        this.perform('initial_output')
        $('.loading-caption').removeClass('hidden')
      },
      received: function (data) {
        outputDiv.append(data.line + "\n")
        window.scrollTo(0, outputDiv[0].scrollHeight)

        if (data.status === 'success' || data.status === 'error') {
          window.location.reload()
        }
      }
    }
  )
})
