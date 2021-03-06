define [
  'app'
  'backbone'
  'marionette'

  'views/meal/viewHome'

  'collections/meals'

  'text!templates/home/day.html'

  'moment'
], (App, Backbone, Mn, MealView, MealsCollection, Template, moment) ->

  DayView = Mn.CompositeView.extend
    className: "weekday"

    childView: MealView

    template: _.template Template
    templateHelpers: ->
      order_date = @collection.first().get('order_date')
      date: moment(order_date).format('DD MMMM YYYY')


    initialize: ->
      @collection = new MealsCollection(_.values(@options.model.toJSON()))


  DayView
