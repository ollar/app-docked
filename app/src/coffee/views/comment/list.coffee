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
  'behaviors/paginate'
], (App, $, _, Mn, CommentsCollection, CommentView, EmptyView, CommentsListTemplate, translate, Sort, SelectAll, Paginate) ->

  CommentsListView = Mn.CompositeView.extend
    className: "pure-menu comments-list menu-wrapper"

    collection: new CommentsCollection()

    childView: CommentView
    childViewContainer: '.pure-menu-list'

    emptyView: EmptyView

    events: {}

    initialize: (options)->
      @collection.fetch()

    template: _.template CommentsListTemplate
    templateHelpers: ->
      t: translate

    behaviors:
      Sort:
        behaviorClass: Sort
      SelectAll:
        behaviorClass: SelectAll
      Paginate:
        behaviorClass: Paginate

  CommentsListView
