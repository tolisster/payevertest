window.Payever or= {}

class Payever.SettingsView extends Backbone.View
	el: '#main-content'

	initialize: ->
		@listenTo @model, 'change', @render

	events:
		'click .btn-edit': 'edit'

	render: ->
		user = @model.get('user')
		for field of user
			value = ''
			if field == 'userGender'
				value = if user[field] == 1 then "Female" else "Male"
			else if field == 'userBirthday'
				value = moment(user[field]).format("DD MMMM YYYY")
			else
				value = user[field]
			@$("[data-bind=\"#{field}\"]").text(value)

	edit: (event) ->
		settingsModalView = new Payever.SettingsModalView
			model: @model
		Payever.App.root.showChildView('modal', settingsModalView)

class Payever.SettingsModalView extends Payever.FormView
	template: '#settings-edit-template'

	className: 'modal-dialog modal-fullpage'

	ui:
		form: 'form'

	onShow: ->
		@model.url = @ui.form.prop 'action'

		@$('.js-datepicker').datetimepicker
			viewMode: 'years'
			format: 'YYYY-MM-DD'

	updateModel: ->
		@model.set @ui.form.serializeJSON()

	onSuccess: (model) ->
		@$el.parent().modal 'hide'

	fieldSelector: -> 'user'
