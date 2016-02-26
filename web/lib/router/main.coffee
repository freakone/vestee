Router.map ->
  @route "home",
    path: "/"
    layoutTemplate: "homeLayout"

  @route "dashboard",
    path: "/dashboard"
    waitOn: ->
      [
        subs.subscribe 'devices', this.userId
      ]
    data: ->
      devices: Devices.find({},{sort: {createdAt: -1}}).fetch()

  @route "charts",
    path: '/charts/:_id'
    waitOn: ->
      [
        subs.subscribe 'devices', this.userId
      ]
    data: ->
      Devices.findOne(this.params._id)
