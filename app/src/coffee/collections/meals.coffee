define [
  'app'
  'backbone'
  'models/meal'
], (App, Backbone, MealModel)->
  MealsCollection = Backbone.Collection.extend
    model: MealModel

    url: App.url '/meal/'

    parse: (data)->
      return data.meals

    initialize: (options)->
      @options = options || {}

    comparator: 'day_linked'

  MealsCollection
