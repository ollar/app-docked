define [
  'backbone'
], (Backbone) ->

  class Model extends Backbone.Model

    urlRoot: '/comment/'

    defaults:
      user_id: 1
      meal_id: 1
      content: ''

    initialize: (args...)->
      super
