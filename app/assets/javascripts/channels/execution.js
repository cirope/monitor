/* global App */

$(document).on('ready turbolinks:load', function () {
  var body      = document.querySelector('body')
  var outputDiv = $('[data-actioncable-watch="execution"]')

  if (!outputDiv.length) return

  var Status = {
    check: function (data) {
      var lastStatus = $('[data-status]').data('status')
      var lastPid    = +$('[data-pid]').data('pid')
      var url        = $('[data-status-refresh-url]').data('statusRefreshUrl')

      if (lastStatus !== data.status || (data.pid && lastPid !== data.pid))
        Status._refresh(url, data.finished)
    },

    _refresh: function (url, finished) {
      if (url && finished) {
        jQuery.getScript(url)
      }
    }
  }

  var Output = {
    append: function (data) {
      outputDiv.data('order', data.order)
      outputDiv.append(data.line)

      Status.check(data)

      body.scrollIntoView(false)

      Output._retrieveNextLines()
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

        Output.append(data)
      }
    }
  }

  var execution = {
    newLine: function (data) {
      var lastOrder = outputDiv.data('order') || 0

      if (data.order === lastOrder + 1) {
        Output.append(data)
      } else {
        var buffer = outputDiv.data('buffer') || []

        outputDiv.data('buffer', buffer.concat(data))
      }
    }
  }

  setTimeout(function () {
    $('.loading-caption').removeAttr('hidden')
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
})
