Template.charts.rendered = () ->
    console.log(Measurements.find().fetch())
    window.dispatchEvent(new Event('resize'));

Template.charts.helpers
    dataChart: (sensorDiv, sensorId, sensorName, sensorUnit) ->
        data = Measurements.find({id: sensorId}).fetch()

        style =
            title:
                text: sensorName

            rangeSelector:
                selected: 0
                buttons:
                    [
                        {
                            type: 'minute'
                            count: 15
                            text: '15min'
                        }
                        {
                            type: 'minute'
                            count: 60
                            text: '1h'
                        }
                        {
                            type: 'day'
                            count: 1
                            text: '1day'
                        }
                        {
                            type: 'all',
                            text: 'All'
                        }
                    ]
            series:
                [
                    tooltip:
                        valueSuffix: sensorUnit

                    animation: false
                    lineWidth: 2
                    name: sensorName
                    marker:
                        enabled: true
                        radius: 3
                    data: data.map (item) ->
                        [item.createdAt.valueOf(), item.value]
                ]

        Meteor.defer () ->
            $('#' + sensorDiv).highcharts('StockChart', style)
            # Highcharts.chart sensorDiv, style
