Template.charts.rendered = () ->
    console.log(Measurements.find().fetch())

Template.charts.dataChart = (sensorId, sensorName, sensorUnit) ->
    data = Measurements.find({id: sensorId}).fetch()

    chart:
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow:false
    title:
        text: sensorName
    tooltip:
        valueSuffix: sensorUnit
    xAxis:
        data.map (item) ->
            item.createdAt
    yAxis:
        plotLines:
            [
                value: 0
                value: 1
                color: '#808080'
            ]
    series:
        [
            name: sensorName
            data: data.map (item) ->
                item.value
        ]


