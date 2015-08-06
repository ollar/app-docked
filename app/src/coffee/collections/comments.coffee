define [
  'underscore'
  'backbone'
  'models/comment'
], (_, Backbone, CommentModel) ->

  class Collection extends Backbone.Collection

    model: CommentModel

    url: '/comment/'

    parse: (data)->
      return data.comments

    initialize: (args...)->
      super

    comparator: 'timestamp_created'
