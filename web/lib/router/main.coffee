Router.map ->
  @route "home",
    path: "/"
    layoutTemplate: "homeLayout"

  @route "dashboard",
    path: "/dashboard"
    waitOn: ->
      [
        subs.subscribe 'devices'
      ]
    data: ->
      devices: Devices.find({},{sort: {createdAt: -1}}).fetch()

  @route "charts",
    path: '/charts/:_id'
    waitOn: ->
      [
        subs.subscribe 'devices'
        subs.subscribe 'sensors', this.params._id
        for sensor in Sensors.find().fetch()
          subs.subscribe 'measurements', this.params._id, sensor.id
      ]
    data: ->
      device: Devices.findOne(this.params._id)
      sensors: Sensors.find().fetch()

