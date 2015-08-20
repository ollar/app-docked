define [
  'marionette'
], (Mn)->
  AddNew = Mn.Behavior.extend
    events:
      'click @ui.addNew': 'addNew'

    addNew: ->
      FrontView = new @options.view()
      FormView = new @options.formView
        front_view: FrontView

      @view.$childViewContainer.prepend FormView.render().el
      @view.$childViewContainer.prepend FrontView.$el.hide()

  AddNew
