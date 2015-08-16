define [
  'jquery'
  'underscore'
  'backbone'
  'models/meal'], ($, _, Backbone, MealModel)->
  MealsCollection = Backbone.Collection.extend
    model: MealModel

    url: '/meal/'

    parse: (data)->
      return data.meals

    initialize: (options)->
      @options = options || {}

    comparator: 'day_linked'

  MealsCollection
