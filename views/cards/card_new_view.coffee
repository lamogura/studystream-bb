class StreamApp.Views.CardNewView extends Backbone.View
	template: JST['cards/card_edit_template']

	initialize: ->
		@model.view = this

	render: ->
		@$el.html @template(@model.toJSON())
		@$el.find(".save-button:first").click => @save_card()
		@$el.find(".cancel-button:first").click => @edit_done()
		return this

	edit_done: (withChanges=null) -> @trigger('edit-card:done', withChanges)

	cancel: -> @edit_done()

	save_card: ->
		changes = 
			entry:   @$el.find('.card-entry').val()
			reading: @$el.find('.card-reading').val()
			defn:    @$el.find('.card-defn').val()

		@edit_done(changes)