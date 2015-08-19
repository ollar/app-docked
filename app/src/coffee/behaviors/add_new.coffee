define [
  'marionette'
], (Mn)->
  AddNew = Mn.Behavior.extend
    events:
      'click @ui.addNew': 'addNew'

    addNew: ->
      FormView = new @options.formView
        front_view: @options.view
      # @view.$el.prepend FormView.render().el
      @view.children.add FormView.render().el

  AddNew
