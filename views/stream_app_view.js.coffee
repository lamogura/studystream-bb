class StreamApp.Views.StreamAppView extends Backbone.View
	testMethod: 'all'

	initialize: (cards) ->
		@streamSelectView = new StreamApp.Views.StreamSelectView
			el: $('#stream-select-view')

		# TODO: add listener to this
		$('#create-card .btn:first').click (e) => @streamView.trigger('create-card-button:click', e.currentTarget)

		@streamView = new StreamApp.Views.StreamView
			el: $('#stream')
		@streamView.appView = this
		@streamView.cardsView.collection.reset(cards)
		
		@render()

	render: ->
		@streamView.render()
		return this
	
	loadStream: (stream) ->
		@testMethod = stream.testMethod
		listener.trigger('stream:changed', stream) for listener in [@streamSelectView, @streamView]