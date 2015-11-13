define [
  'app'
  'backbone'
], (App, Backbone) ->

  CommentModel = Backbone.Model.extend

    urlRoot: App.url '/comment/'

    defaults:
      user_id: 1
      meal_id: 1
      content: ''

  CommentModel
