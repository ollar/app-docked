define [
  'jquery'
  'underscore'
  'backbone'
  'models/meal'
  'collections/meals'], ($, _, Backbone, MealModel, MealsCollection)->
  NWMealsCollection = MealsCollection.extend
    url: '/'

  NWMealsCollection
