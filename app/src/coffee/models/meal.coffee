define [
  'jquery'
  'underscore'
  'backbone'], ($, _, Backbone)->
  MealModel = Backbone.Model.extend
    urlRoot: '/meal/'

    defaults: ->
      title: ''
      description: ''
      category: 0
      day_linked: 0
      enabled: no
      source_price: 0
      price: 0

    validate: (attributes, options) ->
      return 'required field' if attributes.title.length == 0 || attributes.description.length == 0

  MealModel
