window.Payever or= {}

class PayeverApp extends Backbone.Marionette.Application
	setRootLayout: ->
		@root = new Payever.RootLayout()

Payever.App = new PayeverApp()

Payever.App.on 'before:start', ->
	Payever.App.setRootLayout()
