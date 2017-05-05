$(document).on('turbolinks:load', function () {
  $('.ct-chart').parent().trigger('object.mt.added')
})

$(document).on('object.mt.added', function (event) {
  var $chart  = $(event.currentTarget).find('.ct-chart')
  var options = $chart.data('options')
  var data    = {
    labels: $chart.data('labels'),
    series: $chart.data('series')
  }

  if ($chart.length)
    new Chartist.Pie($chart.get(0), data, options)
})

$(document).on('click', '[data-graph-type]', function (event) {
  var $link   = $(event.currentTarget)
  var $chart  = $('[data-graph="' + $link.data('graphTarget') + '"]')
  var chart   = $chart.get(0)
  var type    = $link.data('graphType')
  var options = $chart.data('options')
  var data    = {
    labels: $chart.data('labels'),
    series: type === 'pie' ? $chart.data('series') : [$chart.data('series')]
  }

  event.preventDefault()

  if ($chart.length) {
    if (type === 'line') {
      new Chartist.Line(chart, data, options)
    } else if (type === 'bar') {
      new Chartist.Bar(chart, data, options)
    } else {
      new Chartist.Pie(chart, data, options)
    }
  }
})
