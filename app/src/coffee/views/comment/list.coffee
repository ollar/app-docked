define [
  'app'
  'marionette'

  'collections/comments'

  'views/comment/view'
  'views/common/empty'

  'text!templates/comment/list_view.html'

  'translate'
  'behaviors/select_all'
  'behaviors/infinite_load'
], (App, Mn, CommentsCollection, CommentView, EmptyView, CommentsListTemplate, translate, SelectAll, Infinite) ->

  CommentsListView = Mn.CompositeView.extend
    className: "pure-menu comments-list menu-wrapper"

    collection: new CommentsCollection()

    childView: CommentView
    childViewContainer: '.pure-menu-list'

    emptyView: EmptyView

    events: {}

    initialize: ->
      @collection.fetch()

    template: _.template CommentsListTemplate
    templateHelpers: ->
      t: translate

    behaviors:
      SelectAll:
        behaviorClass: SelectAll
      Infinite:
        behaviorClass: Infinite

  CommentsListView
