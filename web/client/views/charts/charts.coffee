Template.charts.rendered = () ->
    Meteor.defer () ->
        window.onresize = () ->
            for chart in $(".chart")
                $("#" + chart.id).highcharts().setSize($("#main_container").width(), 400)

Template.charts.helpers
    dataChart: (sensorDiv, sensorId, deviceId) ->
        sensor = Sensors.findOne({id: sensorId, owner: deviceId})
        data = Measurements.find({id: sensor.id, owner: deviceId}).fetch()

        style =
            chart:
                renderTo: sensorDiv
            rangeSelector:
                selected: 0
                buttons:
                    [
                        {
                            type: 'minute'
                            count: 15
                            text: '15m'
                        }
                        {
                            type: 'minute'
                            count: 60
                            text: '1h'
                        }
                        {
                            type: 'day'
                            count: 1
                            text: '1d'
                        }
                        {
                            type: 'day'
                            count: 7
                            text: '1w'
                        }
                        {
                            type: 'all',
                            text: 'All'
                        }
                    ]
            series:
                [
                    tooltip:
                        valueSuffix: sensor.unit

                    animation: false
                    lineWidth: 3
                    name: sensor.name
                    marker:
                        enabled: true
                        radius: 4
                    data: data.map (item) ->
                        [item.createdAt.valueOf() - item.createdAt.getTimezoneOffset() * 60 * 1000, item.value]
                ]
        Meteor.defer () ->
            style.chart.width = $("#main_container").width()
            Highcharts.StockChart style
