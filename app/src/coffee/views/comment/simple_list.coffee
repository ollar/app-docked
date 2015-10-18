define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'views/comment/simple_view'
], (App, $, _, Mn, CommentView) ->
  CommmentsSimpleList = Mn.CollectionView.extend
    initialize: (options)->
      @collection = options.collection

    childView: CommentView
    childViewOptions: ->
      origin: @options.origin

  CommmentsSimpleList
