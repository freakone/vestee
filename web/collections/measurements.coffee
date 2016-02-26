@Measurements = new Meteor.Collection('measurements');

Measurements.before.insert (userId, doc) ->
   throw new Meteor.Error(403, "No sensor with such ID") if not Sensors.findOne({id: doc.id})

Schemas.Measurements = new SimpleSchema(

  id:
    type:Number
    min:0
    max:10

  value:
    type:Number
    decimal:true

  createdAt:
    optional: true
    type: Date
    autoValue: ->
      if this.isInsert
        new Date()
)

Measurements.attachSchema Schemas.Measurements

@StarterSchemas = Schemas
