class StreamApp.Views.StreamSelectView extends Backbone.View

	initialize: ->
		@on('stream:changed', @change_selected_stream, this)
		
	change_selected_stream: (stream) ->
		@$el.find('a').removeClass('active')
		@$el.find("a[name='#{stream.name}']").addClass('active')
		# @$el.collapse("hide")