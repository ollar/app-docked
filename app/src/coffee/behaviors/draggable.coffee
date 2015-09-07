define [
  'backbone'
  'marionette'
  'jquery.hammer'
], (Backbone, Mn, hammer)->
  MoveModel = Backbone.Model.extend
    defaults:
      oldX: 0
      oldY: 0
      X: 0
      Y: 0

  DeltaModel = null

  Draggable = Mn.Behavior.extend
    defaults:
      direction: 'A'
      maxMove: 200
      callback: null

    initialize: ->
      @move = new MoveModel()

      @listenTo @move, 'change:X change:Y', (model)->
        @$el.css({'transform': 'translate3d('+model.get('X')+'px, '+model.get('Y')+'px, 0)'})

    events:
      "panstart @ui.panEl": "start"
      "panend @ui.panEl": "end"

      "panmove @ui.panEl": "panmove"

    start: (e)->
      @$el.addClass 'dragged'

    end: (e)->
      @$el.removeClass 'dragged'

      @move.set({'oldX': @move.get('X'), 'oldY': @move.get('Y')})

      if @options.callback?
        @options.callback()

    panmove: (e)->
      if @options.direction in ['H', 'A']
        @move.set('X', @move.get('oldX') + e.gesture.deltaX)

      if @options.direction in ['V', 'A']
        @move.set('Y', @move.get('oldY') + e.gesture.deltaY)

      # return if Math.abs(@delta.X) > @options.maxMove || Math.abs(@delta.Y) > @options.maxMove

    onRender: ->
      @hammer = @ui.panEl.hammer()

      @

  Draggable
