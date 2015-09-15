define [
  'app'
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'views/meal/view'

  'collections/meals'

  'text!templates/home/title.html'

  'moment'
], (App, $, _, Backbone, Mn, MealView, MealsCollection, TitleTemplate, moment) ->

  DayView = Mn.CollectionView.extend

    className: "weekday"

    childView: MealView

    title: _.template(TitleTemplate)

    initialize: (options)->
      @options = options || {}
      @collection = new MealsCollection(_.values(options.model.toJSON()))

    onRender: ->
      order_date = @collection.first().get('order_date')
      @$el.prepend(@title({date: moment(order_date).format('DD MMMM YYYY')}))

  DayView
