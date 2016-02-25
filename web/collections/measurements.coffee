@Measurements = new Meteor.Collection('measurements');

Measurements.before.insert (userId, doc) ->
   throw new Meteor.Error(403, "No such API key") if not Keys.findOne({key: doc.key})

Schemas.Measurements = new SimpleSchema(

  name:
    type:String
    max: 100

  id:
    type:Number
    min:0
    max:10

  value:
    type:Number
    decimal:true

  key:
    type:String
    max: 40

  createdAt:
    optional: true
    type: Date
    autoValue: ->
      if this.isInsert
        new Date()
)

Measurements.attachSchema Schemas.Measurements

@StarterSchemas = Schemas
