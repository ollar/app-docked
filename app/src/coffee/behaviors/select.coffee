define [
  'app'
  'marionette'
], (App, Mn) ->
  Select = Mn.Behavior.extend
    defaults:
      select: no

    events:
      'click': 'toggleState'

    toggleState: ->
      @options.select = !@options.select
      @$el.toggleClass 'selected', @options.select
      @

  Select
