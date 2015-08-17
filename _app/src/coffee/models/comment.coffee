define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Model extends Backbone.Model

    urlRoot: '/comment/'

    defaults:
      user_id: 0
      meal_id: 0
      content: ''

    initialize: (args...)->
      super
