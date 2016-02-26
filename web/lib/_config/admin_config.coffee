@AdminConfig =
	name: Config.name
	collections:
		Comments:
			color: 'green'
			icon: 'comments'
			extraFields: ['doc', 'owner']
			tableColumns: [
				{ label: 'Content', name: 'content' }
				{ label: 'Post', name: 'docTitle()', template: 'adminPostCell' }
				{ label: 'User', name: 'author()', template: 'adminUserCell' }
			]
			children: [
				{
					find: (comment) ->
						Meteor.users.find comment.owner, limit: 1
				}
			]
	dashboard:
		homeUrl: '/dashboard'
	autoForm:
		omitFields: ['createdAt', 'updatedAt']
