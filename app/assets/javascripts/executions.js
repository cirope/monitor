$(document).on('ready turbolinks:load', function () {
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (! outputDiv.length)
    return

  var body        = body || document.querySelector('body')
  var executionId = outputDiv.data('actioncableWatchExecutionId')

  $('.loading-caption').removeClass('hidden')

  App.cable.subscriptions.create(
    {
      channel: 'ExecutionChannel',
      id:      executionId
    },

    {
      connected: function () {
        this.perform('fetch')
      },

      disconnected: function () {
        $('.loading-caption').addClass('hidden')
      },

      received: function (data) {
        outputDiv.append(data.line)
        body.scrollIntoView(false)

        if (data.status === 'success' || data.status === 'error')
          window.location.reload()
      }
    }
  )
})
