window.Payever or= {}

class Payever.FormView extends Backbone.Marionette.ItemView
	constructor: ->
		super
		@listenTo this, 'render', @hideActivityIndicator
		@listenTo this, 'save:form:success', @success
		@listenTo this, 'save:form:failure', @failure

	delegateEvents: (events)->
		@ui = _.extend @_baseUI(), _.result(this, 'ui')
		@events = _.extend @_baseEvents(), _.result(this, 'events')
		super events

	#tagName: 'form'

	_baseUI: ->
		submit: 'button[type="submit"]'
		activityIndicator: '.spinner'

	_baseEvents: ->
		eventHash = {}

		eventHash["click #{@ui.submit}"] = @processForm
		eventHash

	processForm: (e) ->
		e.preventDefault()
		@showActivityIndicator()

		# remove errors on repeated submit
		@$('.has-error').removeClass 'has-error'
		@$('.error-block').remove()

		@updateModel()
		@saveModel()

	updateModel: ->
		throw new Error 'implement #updateModel in your FormView subclass to update the attributes of @model'

	saveModel: ->
		callbacks =
			success: => @trigger 'save:form:success', @model
			error: (model, response) => @trigger 'save:form:failure', model, response

		@model.save {}, callbacks

	success: (model) ->
		@render()
		@onSuccess(model)

	onSuccess: (model) -> null

	# recursively go to child fields (password: [first: {...}, second: {...}] )
	invalidChildren: (children, fieldSelector) ->
		for field_key, field_value of children
			if (field_value.children)
				@invalidChildren(field_value.children, "#{fieldSelector}[#{field_key}]")

			else if field_value.errors
				messages = for message in field_value.errors
					"<span class=\"help-block error-block\">#{message}</span>"

				@$("[name=\"#{fieldSelector}[#{field_key}]\"]").parent().addClass('has-error').append messages

	failure: (model, response) ->
		if response.responseJSON.code == 400
			@invalidChildren response.responseJSON.errors.children, @fieldSelector()

		@hideActivityIndicator()
		@onFailure model, response

	onFailure: (model, response) -> null

	showActivityIndicator: ->
		@ui.activityIndicator.show()
		@ui.submit.prop('disabled', true)

	hideActivityIndicator: ->
		@ui.activityIndicator.hide()
		@ui.submit.prop('disabled', false)
