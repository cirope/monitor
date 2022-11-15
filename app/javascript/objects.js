/* global Chartist */
+function () {
  var renderChart = function ($chart, type) {
    var type      = type || 'pie'
    var container = document.querySelector('#' + $chart.attr('id'))
    var options   = {
      chart: {
        id:   $chart.attr('id'),
        type: type,
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

      renderChart($chart, type)
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
      renderChart($chart, type)
  })
}()
