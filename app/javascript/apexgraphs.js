/* global ApexCharts */
+function () {
  var renderChart = function ($chart, type, height) {
    var type      = type   || 'pie'
    var height    = height || 'auto'
    var container = document.querySelector('#' + $chart.attr('id'))
    var options   = {
      chart: {
        type:   type,
        height: height,
        id:     $chart.attr('id')
      }
    }

    if (type == 'pie') {
      options.labels = $chart.data('labels')
      options.series = $chart.data('series')
    } else {
      options.xaxis  = { categories: $chart.data('labels') }
      options.series = [{ name: 'X', data: $chart.data('series') }]
    }

    if (container.firstChild) {
      ApexCharts.exec($chart.attr('id'), 'destroy')
    }

    new ApexCharts(container, options).render()
  }

  $(document).on('turbo:load', function () {
    $('.graph-container').parent().trigger('object.mt.added')
  })

  $(document).on('object.mt.added', function (event) {
    var $charts = $(event.currentTarget).find('.graph-container')

    $charts.each(function (i, chart) {
      var $chart = $(chart)
      var type   = $chart.data('type')
      var height = $chart.data('height')

      renderChart($chart, type, height)
    })
  })

  $(document).on('click', '[data-graph-type]', function (event) {
    var $link  = $(event.currentTarget)
    var $chart = $('[data-graph="' + $link.data('graphTarget') + '"]')
    var type   = $link.data('graphType')

    event.preventDefault()

    $('[data-graph-type]').removeClass('active')
    $link.addClass('active')

    if ($chart.length)
      renderChart($chart, type, 'auto')
  })
}()
