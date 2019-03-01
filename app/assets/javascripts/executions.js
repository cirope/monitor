$(document).on('ready turbolinks:load', function () {
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (! outputDiv.length)
    return

  var body        = body || document.querySelector('body')
  var executionId = outputDiv.data('actioncableWatchExecutionId')

  App.cable.subscriptions.create(
    {
      channel: 'ExecutionChannel',
      id:      executionId
    },

    {
      connected: function () {
        console.log('connected')
        this.perform('fetch')
        $('.loading-caption').removeClass('hidden')
      },

      received: function (data) {
        console.log('receiving', data)
        outputDiv.append(data.line)
        body.scrollIntoView(false)

        if (data.status === 'success' || data.status === 'error') {
          window.location.reload()
        }
      }
    }
  )
})
