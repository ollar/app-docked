define [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'collections/comments'

  'views/comment/view'

  'text!templates/comment/list_view.html'

  'translate'
], (App, $, _, Backbone, Mn, CommentsCollection, CommentView, CommentsListTemplate, translate) ->

  CommentsListView = Mn.CompositeView.extend
    className: "pure-menu comments-list"

    collection: new CommentsCollection()

    childView: CommentView
    childViewContainer: '.pure-menu-list'

    events: {}

    initialize: (options)->
      @collection.fetch()

    template: _.template CommentsListTemplate
    templateHelpers: ->
      t: translate

  CommentsListView
