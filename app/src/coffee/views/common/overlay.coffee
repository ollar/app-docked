define [
  'app'
  'marionette'
], (App, Mn)->
  Overlay = Mn.ItemView.extend
    el: $('<div />')
    template: no

    events:
      'click': 'close'

    onRender: ->
      _.delay =>
        @$el.addClass 'opened'
      , 100

    onDestroy: ->
      @destroy()

    close: ->
      App.overlay.empty()

  Overlay
