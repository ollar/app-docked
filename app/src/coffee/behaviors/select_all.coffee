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
        if child.children
          child.children.each (subchild)->
            subchild.trigger 'this:clicked'

        child.trigger 'this:clicked'

  SelectAll
