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
      callback: no

    initialize: ->
      @move = new MoveModel()

      @listenTo @move, 'change:X change:Y', (model)->
        console.log model
        @$el.css({'transform': 'translate3d('+model.get('X')+'px, '+model.get('Y')+'px, 0)'})

    events:
      "mousedown @ui.panEl": "touchStart"
      "touchstart @ui.panEl": "touchStart"
      "mouseup @ui.panEl": "touchEnd"
      "touchend @ui.panEl": "touchEnd"

      "pan @ui.panEl": "pan"

    touchStart: ->
      @$el.addClass 'dragged'

    touchEnd: (e)->
      @$el.removeClass 'dragged'

      console.log @move.toJSON()

      @move.set({'oldX': @move.get('X'), 'oldY': @move.get('Y')})

      console.log @move.toJSON()

      if @options.callback?
        @options.callback()

    pan: (e)->
      if @options.direction in ['H', 'A']
        @move.set('X', @move.get('oldX') + e.gesture.deltaX)

      if @options.direction in ['V', 'A']
        @move.set('Y', @move.get('oldX') + e.gesture.deltaY)

      # return if Math.abs(@delta.X) > @options.maxMove || Math.abs(@delta.Y) > @options.maxMove

    onRender: ->
      @hammer = @ui.panEl.hammer()

      @

  Draggable
