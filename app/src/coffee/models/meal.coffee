define [
  'app'
  'backbone'
], (App, Backbone)->
  MealModel = Backbone.Model.extend
    urlRoot: App.url '/meal/'

    initialize: ->
      @attributes.daysObj = {0: 'Monday', 1: 'Tuesday', 2: 'Wednesday', 3: 'Thursday', 4: 'Friday'}
      @attributes.categoriesObj = {0: 'first', 1: 'second', 2: 'third', 3: 'forth'}

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
