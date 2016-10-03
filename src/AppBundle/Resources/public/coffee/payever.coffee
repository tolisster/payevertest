window.Payever or= {}

$ ->
	Payever.App.on 'start', ->
		controller = new Payever.Controller()
		controller.router = new Payever.Router
			controller: controller

		controller.start()
		Backbone.history.start()

	Payever.App.start()
