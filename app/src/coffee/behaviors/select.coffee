define [
  'marionette'
], (Mn) ->
  Select = Mn.Behavior.extend
    initialize: ->
      @view.select = no

    events:
      'click': 'toggleState'

    toggleState: ->
      @select = !@select
      @$el.toggleClass 'selected', @select
      @

  Select
