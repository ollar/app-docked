define [
  'jquery'
  'underscore'
  'backbone'
  'models/meal'
  'collections/meals'], ($, _, Backbone, MealModel, MealsCollection)->
  NWMealsCollection = Backbone.Collection.extend
    url: '/'

    parse: (data)->
      return data.days

  NWMealsCollection
