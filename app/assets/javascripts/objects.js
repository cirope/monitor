+function () {
  var renderChart = function ($chart, type) {
    var chart   = $chart.get(0)
    var options = $chart.data('options')
    var data    = {
      labels: $chart.data('labels'),
      series: type === 'pie' ? $chart.data('series') : [$chart.data('series')]
    }

    if (type === 'line') {
      new Chartist.Line(chart, data, options)
    } else if (type === 'bar') {
      new Chartist.Bar(chart, data, options)
    } else {
      new Chartist.Pie(chart, data, options)
    }
  }

  $(document).on('turbolinks:load', function () {
    $('.ct-chart').parent().trigger('object.mt.added')
  })

  $(document).on('object.mt.added', function (event) {
    var $charts = $(event.currentTarget).find('.ct-chart')

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

    if ($chart.length)
      renderChart($chart.get(0), type)
  })
}()
