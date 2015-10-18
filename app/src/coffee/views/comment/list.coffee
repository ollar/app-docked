define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'collections/comments'

  'views/comment/view'
  'views/common/empty'

  'text!templates/comment/list_view.html'

  'translate'
  'behaviors/sort'
  'behaviors/select_all'
  'behaviors/infinite_load'
], (App, $, _, Mn, CommentsCollection, CommentView, EmptyView, CommentsListTemplate, translate, Sort, SelectAll, Infinite) ->

  CommentsListView = Mn.CompositeView.extend
    className: "pure-menu comments-list menu-wrapper"

    collection: new CommentsCollection()

    childView: CommentView
    childViewContainer: '.pure-menu-list'

    emptyView: EmptyView

    events: {}

    initialize: (options)->
      @collection = options.collection || @collection

      @collection.fetch()

    template: _.template CommentsListTemplate
    templateHelpers: ->
      t: translate

    behaviors:
      Sort:
        behaviorClass: Sort
      SelectAll:
        behaviorClass: SelectAll
      Infinite:
        behaviorClass: Infinite

  CommentsListView
