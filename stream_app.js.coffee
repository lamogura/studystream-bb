window.StreamApp =
	Models: {}
	Collections: {}
	Views: {}
	Routers: {}
	
	init: (options={}) -> 
		# set the swipe threshold on startup
		$.event.special.swipe.horizontalDistanceThreshold = 130

		# start the routers and lets get it going
		window.SSRouter = new StreamApp.Routers.StreamAppRouter(options.cards)
		Backbone.history.start()

	debug: true
	
	Streams:
		classic:
			name: 'classic'
			sortField: 'score'
			testMethod: 'all'
			filter: 'all'

		reading:
			name: 'reading'
			sortField: 'readingScore'
			testMethod: 'reading'
			filter: 'all'

		reverse:
			name: 'reverse'
			sortField: '-score'
			testMethod: 'all'
			filter: 'all'

		definition:
			name: 'definition'
			sortField: 'defnScore'
			testMethod: 'definition'
			filter: 'all'

		random:
			name: 'random'
			sortField: 'random'
			testMethod: 'all'
			filter: 'all'

		starred:
			name: 'starred'
			sortField: 'score'
			testMethod: 'all'
			filter: 'starred'

		recent:
			name: 'recent'
			sortField: 'lastReviewedAt'
			testMethod: 'all'
			filter: 'all'