Meteor.publish 'keys', () ->
  Keys.find({"owner": this.userId}) if this.userId
