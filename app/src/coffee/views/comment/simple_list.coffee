define [
  'app'
  'marionette'

  'views/comment/simple_view'
  'views/common/empty'
], (App, Mn, CommentView, EmptyView) ->
  CommmentsSimpleList = Mn.CollectionView.extend
    className: 'inner'
    childView: CommentView
    childViewOptions: ->
      origin: @options.origin

    emptyView: EmptyView

  CommmentsSimpleList
