define [
  'marionette'
], (Mn)->
  LoadingBehavior = Mn.Behavior.extend
    initialize: ->
      @listenTo(@view, 'busy:start', @appendLoader)
      @listenTo(@view, 'busy:stop', @removeLoader)

    createLoader: ->
      @loader = $('<div />', {'class': 'item-loader'})
      @loader

    appendLoader: ->
      @view.$el.append @createLoader()

    removeLoader: ->
      @loader.remove() if @loader?


  LoadingBehavior
