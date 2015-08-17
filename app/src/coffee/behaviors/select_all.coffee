define [
  'marionette'
], (Mn)->
  SelectAll = Mn.Behavior.extend
    ui:
      button: '.select-all'

    events:
      'click @ui.button': 'selectAll'

    selectAll: ->
      @view.children.each (child)->
        child.trigger 'this:clicked'

  SelectAll
