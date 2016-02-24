Meteor.publish 'keys', () ->
  console.log(this.userId)
  Keys.find({"owner": this.userId}) if this.userId
