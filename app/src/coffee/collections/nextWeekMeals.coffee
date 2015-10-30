define [
  'backbone'
  'models/meal'
  'collections/meals'], (Backbone, MealModel, MealsCollection)->
  NWMealsCollection = Backbone.Collection.extend
    url: '/'

    parse: (data)->
      return data.days

  NWMealsCollection
