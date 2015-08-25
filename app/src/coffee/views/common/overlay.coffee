define [
  'app'
  'marionette'
], (App, Mn)->
  Overlay = Mn.ItemView.extend
    el: $('<div />')
    template: no

    initialize: ->
      @listenTo App.vent, 'overlay:show', @show
      @listenTo App.vent, 'overlay:hide', @hide

    events:
      'click': -> App.vent.trigger 'overlay:clicked'

    show: ->
      @$el.addClass 'opened'

    hide: ->
      @$el.removeClass 'opened'

  Overlay
