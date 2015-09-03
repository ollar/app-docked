define [
  'marionette'
  'jquery.hammer'
], (Mn, hammer)->
  Draggable = Mn.Behavior.extend
    defaults:
      direction: 'A'
      maxMove: 200
      callback: no

    initialize: ->
      no

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
      _.delay =>
        @$el.removeAttr 'style'
      , 15
      if @options.callback?
        @options.callback()

    pan: (e)->
      @move =
        X: if @options.direction in ['H', 'A'] then e.gesture.deltaX else 0
        Y: if @options.direction in ['V', 'A'] then e.gesture.deltaY else 0

      return if Math.abs(@move.X) > @options.maxMove || Math.abs(@move.Y) > @options.maxMove

      @$el.css({'transform': 'translate('+@move.X+'px, '+@move.Y+'px)'})


    onRender: ->
      @hammer = @ui.panEl.hammer()

      @

  Draggable
