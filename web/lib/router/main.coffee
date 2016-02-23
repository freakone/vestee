Router.map ->
  @route "home",
    path: "/"
    layoutTemplate: "homeLayout"

  @route "dashboard",
    path: "/dashboard"
    waitOn: ->
      [
        subs.subscribe 'keys'
      ]
    data: ->
      keys: Keys.find({},{sort: {createdAt: -1}}).fetch()
