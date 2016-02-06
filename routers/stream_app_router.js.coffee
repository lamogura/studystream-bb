class StreamApp.Routers.StreamAppRouter extends Backbone.Router

	initialize: (cards)->
		@streamAppView = new StreamApp.Views.StreamAppView(cards)

	routes:
		'':             'home'
		'stream/:type': 'loadStream'

	home: -> @loadStream('classic')

	loadStream: (type) -> @streamAppView.loadStream StreamApp.Streams[type]