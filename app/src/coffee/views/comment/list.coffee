define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'collections/comments'

  'views/comment/view'

  'text!templates/comment/list_view.html'

  'translate'
  'behaviors/sort'
  'behaviors/select_all'
], (App, $, _, Mn, CommentsCollection, CommentView, CommentsListTemplate, translate, Sort, SelectAll) ->

  CommentsListView = Mn.CompositeView.extend
    className: "pure-menu comments-list menu-wrapper"

    collection: new CommentsCollection()

    childView: CommentView
    childViewContainer: '.pure-menu-list'

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

  CommentsListView
