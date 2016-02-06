class StreamApp.Models.Card extends Backbone.Model
	isTested: false
	# TODO: should let user choose language
	defaults:
		"language": "japanese"
		"entry": ""
		"reading": ""
		"defn": ""

class StreamApp.Collections.CardCollection extends Backbone.Collection
	model: StreamApp.Models.Card
	url: '/cards'

	initialize: () ->
		@sort_by_field()

	sort_by_field: (field='score') ->
		console.log "setting sort to #{field}"
		
		# 1 is normal, -1 flips it
		sortOrder = 1
		if field[0] is '-'
			field = field[1..]
			sortOrder = -1

		@comparator = (card) ->
			switch field
				when 'lastReviewedAt'
					date = new Date(card.get(field))
					return sortOrder * date.getTime() * -1 
				when 'random' then return sortOrder * card.randNum = 0.5 - Math.random()
				else return sortOrder * card.get(field)
		@sort()