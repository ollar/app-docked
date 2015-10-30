define [
  'app'
  'marionette'

  'views/comment/simple_view'
], (App, Mn, CommentView) ->
  CommmentsSimpleList = Mn.CollectionView.extend

    childView: CommentView
    childViewOptions: ->
      origin: @options.origin

  CommmentsSimpleList
