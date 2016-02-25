Meteor.publish 'keys', () ->
  Keys.find({"owner": this.userId}) if this.userId

Meteor.methods
  add_data: (api_key, name, id, value) ->
    if Keys.findOne({key: api_key})
      data = {name: name, id: id, value: value, key: api_key}
      check(data, Measurements.simpleSchema())
      Measurements.insert(data)
      return "ok"


    return "invalid api key"
