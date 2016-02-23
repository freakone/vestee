@Keys = new Meteor.Collection('keys');

Schemas.Keys = new SimpleSchema
	key:
		type:String
		max: 60

	createdAt:
		type: Date
		autoValue: ->
			if this.isInsert
				new Date()

	owner:
		type: String
		regEx: SimpleSchema.RegEx.Id
		autoValue: ->
			if this.isInsert
				Meteor.userId()
		autoform:
			options: ->
				_.map Meteor.users.find().fetch(), (user)->
					label: user.emails[0].address
					value: user._id

Keys.attachSchema(Schemas.Keys)
