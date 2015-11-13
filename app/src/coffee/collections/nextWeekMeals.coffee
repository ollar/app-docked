define [
  'app'
  'backbone'
  'models/meal'
  'collections/meals'], (App, Backbone, MealModel, MealsCollection)->
  NWMealsCollection = Backbone.Collection.extend
    url: App.url '/'

    parse: (data)->
      return data.days

  NWMealsCollection
