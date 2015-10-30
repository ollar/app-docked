define [
  'backbone'
  'models/meal'], (Backbone, MealModel)->
  MealsCollection = Backbone.Collection.extend
    model: MealModel

    url: '/meal/'

    parse: (data)->
      return data.meals

    initialize: (options)->
      @options = options || {}

    comparator: 'day_linked'

  MealsCollection
