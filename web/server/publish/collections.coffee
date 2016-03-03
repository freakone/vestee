Meteor.publish 'devices', () ->
  Devices.find({owner: this.userId}) if this.userId

Meteor.publish 'sensors', (deviceId) ->
  Sensors.find({owner: deviceId}) if deviceId

Meteor.publish 'measurements', (deviceId, sensorId) ->
  Measurements.find({owner: deviceId, id: sensorId}) if deviceId

Meteor.methods
  add_data: (api_key, id, name, unit, value) ->
    if device = Devices.findOne({key: api_key})
      Sensors.upsert(Sensors.findOne({id: id, owner: device._id}), {id: id, name: name, unit: unit, owner: device._id})
      Measurements.insert({id: id, value: value, owner: device._id})
      return "ok"
    return "invalid api key"
