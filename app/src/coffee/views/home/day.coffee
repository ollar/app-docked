define [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'views/meal/view'

  'collections/meals'

  'text!templates/home/day.html'

  'moment'
], (App, $, _, Backbone, Mn, MealView, MealsCollection, Template, moment) ->

  DayView = Mn.CompositeView.extend
    className: "weekday"

    childView: MealView

    template: _.template Template
    templateHelpers: ->
      order_date = @collection.first().get('order_date')
      date: moment(order_date).format('DD MMMM YYYY')


    initialize: (options)->
      @options = options || {}
      @collection = new MealsCollection(_.values(options.model.toJSON()))


  DayView
