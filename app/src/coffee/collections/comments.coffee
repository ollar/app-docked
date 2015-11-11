define [
  'app'
  'backbone'
  'models/comment'
], (App, Backbone, CommentModel) ->
  CommentsCollection = Backbone.Collection.extend

    model: CommentModel

    url: App.url '/comment/'

    parse: (data)->
      return data.comments

    initialize: (options)->
      @options = options || {}

    comparator: 'timestamp_created'

  CommentsCollection
