define [
  'marionette'
], (Mn) ->
  Select = Mn.Behavior.extend
    initialize: ->
      @view.on 'this:clicked', @toggleState

    defaults:
      select: no

    triggers:
      'click': 'this:clicked'

    toggleState: ->
      @options.select = !@options.select
      @$el.toggleClass 'selected', @options.select
      @

  Select
