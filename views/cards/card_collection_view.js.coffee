class StreamApp.Views.CardCollectionView extends Backbone.View

	initialize: ->
		@collection.view = this
		@collection.on("reset", @render, this)
		@collection.on("add", @render, this)
		@collection.on("remove", @render, this)
		@on("change:card:showing-options", @close_previous_card_showing_options, this)
		@on("filter:changed", @render, this)

	render: (filter='all') ->
		@$el.empty() # we need to reloop and render so dump current view

		# TODO: can use this to pin cards to top if we want
		cardsAtTop = _.filter @collection.models, (card) -> card.isAtTop
		@render_card card for card in cardsAtTop.reverse()

		switch filter
			when "starred" then filteredCards = _.filter @collection.models, (card) -> card.get("starred")
			else filteredCards = @collection.models

		for card in filteredCards
			@render_card card unless card in cardsAtTop
		return this

	render_card: (card) ->
		view = new StreamApp.Views.CardView
			model: card
		@$el.append view.render().el

	change_stream: (stream) ->
		# TODO: maybe a better way to do this than add an attribute to the model ??
		for model in @collection.models 
			model.isTested = false 
			model.isAtTop = false
		
		@collection.sort_by_field stream.sortField
		@trigger("filter:changed", stream.filter)

	close_previous_card_showing_options: (currentCard) ->
		@previousCardShowingOptions.view.trigger('change:state', 'initial', true) if @previousCardShowingOptions?
		@previousCardShowingOptions = currentCard