define [
  'marionette'
  'jquery.hammer'
], (Mn, hammer)->
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
      @view.move = new MoveModel()

      @listenTo @view.move, 'change:X change:Y', (model)->
        @$el.css({'transform': 'translate3d('+model.get('X')+'px, '+model.get('Y')+'px, 0)'})

    events:
      "panstart @ui.panEl": "start"
      "panend @ui.panEl": "end"

      "panmove @ui.panEl": "panmove"

    start: (e)->
      @$el.addClass 'dragged'

    end: (e)->
      @$el.removeClass 'dragged'

      @view.move.set({'oldX': @view.move.get('X'), 'oldY': @view.move.get('Y')})

      if typeof(@options.callback) == 'function'
        @options.callback.call(@)

    panmove: (e)->
      if typeof(@options.disable) == 'function'
        return if _.bind(@options.disable, @)()

      @view.move.set('gesture', e.gesture)

      if @options.direction in ['H', 'A']
        @view.move.set('X', @view.move.get('oldX') + e.gesture.deltaX)

      if @options.direction in ['V', 'A']
        @view.move.set('Y', @view.move.get('oldY') + e.gesture.deltaY)

    resetMove: ()->
      @view.move.set({'X': 0, 'Y': 0, 'oldX': 0, 'OldY': 0, 'gesture': {}})

    onRender: ->
      @hammer = @ui.panEl.hammer()

      @

  Draggable
