define [
  'marionette'
], (Mn)->
  SelectAll = Mn.Behavior.extend
    ui:
      button: '.select-all'

    events:
      'click @ui.button': 'selectAll'

    clickChildren: (parent)->
      return if !parent.children?
      parent.children.each (child)=>
        child.trigger 'me:clicked'
        @clickChildren(child)

    selectAll: ->
      @clickChildren(@view)

  SelectAll
