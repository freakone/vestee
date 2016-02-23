# You'll want to replace these functions. They publish the whole
# collection which is problematic after your app grows

Meteor.publish 'keys', ->
	Keys.find()

Meteor.publish 'attachments', ->
	Attachments.find()
