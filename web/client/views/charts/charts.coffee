Template.charts.rendered = () ->
    Meteor.defer () ->
        for sensor in Sensors.find().fetch()
            data = Measurements.find({id: sensor.id}).fetch()

            style =
                title:
                    text: sensor.name
                chart:
                    renderTo: sensor._id
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
                            valueSuffix: sensor.unit

                        animation: false
                        lineWidth: 2
                        name: sensor.name
                        marker:
                            enabled: true
                            radius: 3
                        data: data.map (item) ->
                            [item.createdAt.valueOf(), item.value]
                    ]
            $('#' + sensor._id).highcharts('StockChart', style)
