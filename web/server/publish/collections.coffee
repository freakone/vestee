Meteor.publish 'devices', () ->
  Devices.find({"owner": this.userId}) if this.userId

Meteor.methods
  add_data: (api_key, id, name, unit, value) ->
    device = Devices.findOne({key: api_key})
    if device
      Sensors.upsert(Sensors.findOne({id: id}), {id: id, name: name, unit: unit, owner: device._id})
      Measurements.insert({id: id, value: value})
      return "ok"


    return "invalid api key"
