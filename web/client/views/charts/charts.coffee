Template.charts.rendered = () ->
    Meteor.defer () ->
        window.onresize = () ->
            for chart in $(".chart")
                $("#" + chart.id).highcharts().setSize($("#main_container").width(), 400)

Template.charts.helpers
    active: (indx) ->
        "active" if indx == 0
    last_measurement: (sensorId, deviceId) ->
        sensor = Sensors.findOne({id: sensorId, owner: deviceId})
        item = Measurements.findOne({id: sensorId, owner: deviceId}, {sort: {createdAt: -1}})
        item.value + " " + sensor.unit
    date_style: (sensorId, deviceId) ->
        item = Measurements.findOne({id: sensorId, owner: deviceId}, {sort: {createdAt: -1}})
        time = moment(item.createdAt.valueOf() - item.createdAt.getTimezoneOffset() * 60 * 1000)
        if moment.now() - time > 1000 * 60 * 60 * 12
            "label-danger"
        else
            "label-default"
    last_date: (sensorId, deviceId) ->
        item = Measurements.findOne({id: sensorId, owner: deviceId}, {sort: {createdAt: -1}})
        time = moment(item.createdAt.valueOf() - item.createdAt.getTimezoneOffset() * 60 * 1000)
        time.format("HH:mm  DD MMM")
    dataChart: (sensorDiv, sensorId, deviceId) ->
        sensor = Sensors.findOne({id: sensorId, owner: deviceId})
        data = Measurements.find({id: sensor.id, owner: deviceId}, {sort: {createdAt: 1}}).fetch()

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
                    name: sensor.name
                    data: data.map (item) ->
                        [item.createdAt.valueOf() - item.createdAt.getTimezoneOffset() * 60 * 1000, item.value]
                ]
        Meteor.defer () ->
            style.chart.width = $("#main_container").width()
            Highcharts.StockChart style
