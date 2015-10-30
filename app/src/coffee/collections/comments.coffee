define [
  'backbone'
  'models/comment'
], (Backbone, CommentModel) ->
  CommentsCollection = Backbone.Collection.extend

    model: CommentModel

    url: '/comment/'

    parse: (data)->
      return data.comments

    initialize: (options)->
      @options = options || {}

    comparator: 'timestamp_created'

  CommentsCollection
