window.Payever or= {}

class Payever.Router extends Backbone.Marionette.AppRouter

class Payever.Controller extends Backbone.Marionette.Object
	initialize: ->
		@settings = new Payever.Settings()

	start: ->
		@bindSettingsView(@settings)

	bindSettingsView: (settings) ->
		settingsView = new Payever.SettingsView
			model: settings
