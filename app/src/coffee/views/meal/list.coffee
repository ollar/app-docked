define [
  'jquery'
  'underscore'
  'backbone'
  'marionette'
  'app'
  'collections/meals'
  'views/meal/view'
  'views/common/empty'
  'text!templates/meal/list_view.html'
  'translate'], ($, _, Backbone, Mn, App, MealsCollection, MealView, EmptyView, MealsListTemplate, translate)->
  MealsListView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper'
    collection: new MealsCollection()
    template: _.template(MealsListTemplate)
    templateHelpers: ->
      t: translate
    childView: MealView

    childViewContainer: '.pure-menu-list'

    initialize: ->
      @collection.fetch()

    emptyView: EmptyView

    MealsListView
