Template.charts.rendered = () ->
    console.log(Measurements.find().fetch())
    window.dispatchEvent(new Event('resize'));

Template.charts.helpers
    dataChart: (sensorDiv, sensorId, sensorName, sensorUnit) ->
        data = Measurements.find({id: sensorId}).fetch()

        style =
            chart:
                plotBackgroundColor: null
                plotBorderWidth: null
                plotShadow:false
                spacingRight:10
            title:
                text: sensorName
            tooltip:
                valueSuffix: sensorUnit
            xAxis:
                type: 'datetime'
                labels:
                    format: '{value:%m.%d %H:%M}'
                    rotation: -90
                    align: 'right'
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
                        [item.createdAt.valueOf(), item.value]
                ]

        Meteor.defer () ->
            Highcharts.chart sensorDiv, style
