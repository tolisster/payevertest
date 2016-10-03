window.Payever or= {}

class ModalRegion extends Backbone.Marionette.Region
	el: '#modal'

	constructor: ->
		super
		@on 'show', @showModal, @

	getEl: (selector) ->
		$el = $ selector
		$el.on 'hidden', @close
		$el

	showModal: (view) ->
		view.on 'close', @hideModal, @
		@$el.modal 'show'

	hideModal: ->
		@$el.modal 'hide'

class Payever.RootLayout extends Backbone.Marionette.LayoutView
	el: '#payever-app'

	regions:
		modal: ModalRegion
