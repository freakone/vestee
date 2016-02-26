@Sensors = new Meteor.Collection('sensors');

Sensors.before.insert (userId, doc) ->
   throw new Meteor.Error(403, "No such device") if not Devices.findOne({_id: doc.owner})

Schemas.Sensors = new SimpleSchema(

  name:
    type:String
    max: 100

  unit:
    type:String
    max:10
    optional: true

  id:
    type:Number
    min:0
    max:10

  owner:
    type: String
    regEx: SimpleSchema.RegEx.Id

  createdAt:
    optional: true
    type: Date
    autoValue: ->
      if this.isInsert
        new Date()
)

Measurements.attachSchema Schemas.Measurements

@StarterSchemas = Schemas
