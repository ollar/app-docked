define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'collections/meals'
  'views/meal/view'
  'text!templates/meal/list_view.html'
  'views/list'
  'views/meal/form'], ($, _, Backbone, App, MealsCollection, MealView, MealsListTemplate, ListView, MealFormView)->
  MealsListView = ListView.extend
    initialize: ->
      @listTemplate = MealsListTemplate
      @view = MealView
      @addView = MealFormView

      ListView.prototype.initialize.apply(this, arguments)

      @$list = @$el.find('.pure-menu-list')

      @renderData()

  MealsListView
