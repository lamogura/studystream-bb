class StreamApp.Views.CardView extends Backbone.View
	template: JST['cards/card_template']

	# card states: initial, testingReading, testingDefn, testedAndDisplaying, tested_collapsed, showingOptions
	_state: 'initial'
	change_state: (newState, silentChange=false) ->
		if not silentChange
			if newState is 'showingOptions'
				@model.collection.view.trigger('change:card:showing-options', @model)
		@_state = newState
		@render()

	initialize: ->
		@model.view = this
		@model.on('change', @render, this)
		@model.on('destroy', @remove_view, this)
		@on('change:state', @change_state, this)

	render: ->
		attributes = @model.toJSON()

		# extra vars for templates
		attributes.isTesting = (/^testing_.+/).test(@_state)
		attributes.state = @_state
		attributes.debug = StreamApp.debug

		@$el.html(@template attributes)

		card = @$el.find('.flashcard:first')
		card = @$el.find('.card-options') if card.length is 0 # happens cause we replace this div

		card.addClass('starred')     if @model.get('starred')
		card.addClass('tested-done') if @model.isTested

		# add event handlers based on state
		# TODO: find a better way to manage this ??
		switch @_state
			when 'initial'
				card.css('cursor', 'pointer')
				@enable_mobile_options(card)

				card.click => 
					card.unbind 'click'
					switch @get_test_method()
						when 'all', 'reading' then @trigger('change:state', 'testingReading')
						when 'definition' 		then @trigger('change:state', 'testingDefn')

			when 'showingOptions' 
				card.css('cursor', 'pointer')
				
				# dont want to pin multple events each render
				card.find('.btn').unbind('click').click => @trigger('change:state', 'initial')
				
				card.find('.star-button').click   => @toggle_starred()
				card.find('.bury-button').click   => @bury_card()
				card.find('.edit-button').click   => @edit_card()
				card.find('.delete-button').click => @delete_card()
				# card.find('.close-button').click  => @trigger('change:state', 'initial')

			when 'testingReading'
				card.find('.choice').click (e) =>	
					@answer_card('reading', $(e.currentTarget).hasClass('choice-correct'))
					switch @get_test_method()
						when 'all' then @trigger('change:state', 'testingDefn')
						else @answering_done()

			when 'testingDefn'
				card.find('.choice').click (e) =>	
					@answer_card('defn', $(e.currentTarget).hasClass('choice-correct'))
					@answering_done()

			when 'testedAndDisplaying', 'tested_collapsed'
				card.css('cursor', 'pointer')
				@enable_mobile_options(card)
				card.click =>
					if @_state is 'testedAndDisplaying' 
						@trigger('change:state', 'tested_collapsed') 
					else 
						@trigger('change:state', 'testedAndDisplaying')

		return this

	get_test_method: -> @model.collection.view.streamView.appView.testMethod

	enable_mobile_options: (card) ->
		# this uses the jQuery mobile swipe event
		card.swipe (e) =>	@trigger('change:state', 'showingOptions')

	answer_card: (which_answer, correctly) ->
		id = @model.get('id')

		$.post "/cards/#{id}/reviewed",
				'whichAnswer': which_answer
				'correctly': correctly
		# TODO move these to their own fuction so can DRY up the bury card as weel
		.success (changes) =>
			console.log "answer_card() successful response\n\tchanges:\n"
			console.log changes
			console.log 'updating model with changes.'
			@model.set changes
		.error (resp) -> 
			console.log "error ajaxing id: #{id}\n#{resp}"

	answering_done: ->
		@model.isTested = true
		@trigger('change:state', 'tested_collapsed')
	
	# options menu functions
	# TODO: move this all to its own view
	toggle_starred: ->
		@model.save { starred: not @model.get('starred') }
		@trigger('change:state', 'initial')

	bury_card: ->
		id = @model.get('id')
		$.post "/cards/#{id}/bury", 
			'bury this card'
		.success (changes) =>
			console.log 'answer_card() successful response\n\tchanges:\n'
			console.log changes
			console.log 'updating model with changes.'
			@model.set changes
			@trigger('change:state', 'initial')
			@$el.appendTo(@model.collection.view.el)
		.error (resp) -> 
			console.log "error ajaxing id: #{id}\n#{resp}"
	
	edit_card: ->
		view = new StreamApp.Views.CardEditView
			model: @model
			el: @$el
		@trigger('change:state', 'initial')
		view.on('edit-card:done', @update_card, this)
		view.render()
	
	update_card: (withSomeChanges) ->
		@model.save withSomeChanges
		@render()

	delete_card: ->	@model.destroy() if confirm("Last chance, delete?")

	remove_view: ->	@$el.remove()