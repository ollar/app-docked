define [
  'marionette'
], (Mn)->
  Edit = Mn.Behavior.extend
    ui:
      edit: '.edit'

    events:
      'click @ui.edit': 'editMe'

    editMe: ->
      FormView = new @options.formView
        model: @view.model
        front_view: @view

      @$el.before FormView.render().el
      @$el.hide()

  Edit
