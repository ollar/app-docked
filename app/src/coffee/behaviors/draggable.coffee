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
      gesture: {}

  Draggable = Mn.Behavior.extend
    defaults: ->
      direction: 'A'
      callback: _.bind(@resetMove, @)
      disable: null

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

      if typeof(@options.callback) == 'function'
        @options.callback()

    panmove: (e)->
      if typeof(@options.disable) == 'function'
        return if _.bind(@options.disable, @)()

      @move.set('gesture', e.gesture)

      if @options.direction in ['H', 'A']
        @move.set('X', @move.get('oldX') + e.gesture.deltaX)

      if @options.direction in ['V', 'A']
        @move.set('Y', @move.get('oldY') + e.gesture.deltaY)

    resetMove: ()->
      @move.set({'X': 0, 'Y': 0, 'oldX': 0, 'OldY': 0, 'gesture': {}})

    onRender: ->
      @hammer = @ui.panEl.hammer()

      @

  Draggable
