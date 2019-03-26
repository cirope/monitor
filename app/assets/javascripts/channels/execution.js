$(document).on('ready turbolinks:load', function () {
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (outputDiv.length) {
    var body   = body || document.querySelector('body')
    var output = {
      append: function (data) {
        outputDiv.data('order', data.order)
        outputDiv.append(data.line)

        status.check(data.status)

        body.scrollIntoView(false)

        output._retrieveNextLines()
      },

      _retrieveNextLines: function () {
        var lastOrder = outputDiv.data('order')  || 0
        var buffer    = outputDiv.data('buffer') || []
        var data      = null
        var index     = null

        jQuery.each(buffer, function (i, bufferedData) {
          if (bufferedData.order === lastOrder + 1) {
            data  = bufferedData
            index = i
          }
        })

        if (data) {
          buffer.splice(index, 1)
          outputDiv.data('buffer', buffer)

          output.append(data)
        }
      }
    }
    var execution = {
      newLine: function (data) {
        var lastOrder = outputDiv.data('order') || 0

        if (data.order === lastOrder + 1) {
          output.append(data)
        } else {
          var buffer = outputDiv.data('buffer') || []

          outputDiv.data('buffer', buffer.concat(data))
        }
      }
    }
    var status = {
      check: function (newStatus) {
        var lastStatus = $('[data-status]').data('status')

        if (lastStatus !== newStatus)
          status._refresh()
      },

      _refresh: function () {
        var url = $('[data-status-refresh-url]').data('statusRefreshUrl')

        if (url)
          jQuery.getScript(url)
      }
    }

    setTimeout(function () {
      $('.loading-caption').removeClass('hidden')
    })

    App.cable.subscriptions.create(
      {
        channel: 'ExecutionChannel',
        id:      outputDiv.data('actioncableWatchExecutionId')
      },

      {
        connected: function () {
          this.perform('fetch')
        },

        received: execution.newLine
      }
    )
  }
})
