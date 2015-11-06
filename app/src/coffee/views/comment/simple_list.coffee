define [
  'app'
  'marionette'

  'views/comment/simple_view'
], (App, Mn, CommentView) ->
  CommmentsSimpleList = Mn.CollectionView.extend
    className: 'inner'
    childView: CommentView
    childViewOptions: ->
      origin: @options.origin

  CommmentsSimpleList
