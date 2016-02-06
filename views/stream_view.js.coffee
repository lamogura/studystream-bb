#= require ./cards/card_collection_view
class StreamApp.Views.StreamView extends Backbone.View

	initialize: ->
		@on('stream:changed', @change_stream, this)
		@on('create-card-button:click', @create_new_card, this)

		# save this to the NS so we can export bootstrap from rails
		cards = new StreamApp.Collections.CardCollection
		@cardsView = new StreamApp.Views.CardCollectionView
			collection: cards
		@cardsView.streamView = this

	render: ->
		@$el.html( @cardsView.render().el)
		return this

	change_stream: (stream) -> 
		@cardsView.change_stream stream

	create_new_card: ->
		newCard = new StreamApp.Models.Card
		
		view = new StreamApp.Views.CardNewView
			model: newCard
			el: $("#modal-edit-card")

		view.on('edit-card:done', @new_card_done, this)
		$(view.render().el).modal('show')

	new_card_done: (withAttributes) ->
		# TODO: saving new card doenst refersh after server save, fix this
		if withAttributes?
			newCard = @cardsView.collection.create withAttributes, { silent: true } 
			newCard.isAtTop = true
			@cardsView.render()
		$("#modal-edit-card").modal('hide')