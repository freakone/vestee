Router.map ->
  @route "home",
    path: "/"
    layoutTemplate: "homeLayout"

  @route "dashboard",
    path: "/dashboard"
    waitOn: ->
      [
        subs.subscribe 'keys', this.userId
      ]
    data: ->
      keys: Keys.find({},{sort: {createdAt: -1}}).fetch()

  @route "device",
    path: '/device/:_id'
    onBeforeAction: ->

    data: ->
      Keys.findOne(this.params._id)
