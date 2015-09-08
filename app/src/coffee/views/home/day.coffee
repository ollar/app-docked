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

      loggedUser = App.ventFunctions.getLoggedUser()
      local_orders = _.groupBy loggedUser.get('orders'), (order)->order.order_date
      local_comments = loggedUser.get('comments')

      @collection.each (model)=>
        @children.findByModel(model).$el.attr 'data-order-date', model.get('order_date')
        if _.contains(_.pluck(local_orders[order_date], 'meal_id'), model.get('id'))
          match = _.find local_orders[order_date], (order)-> order.meal_id == model.get('id')

          @children.findByModel(model).orderSuccess(match.quantity, match.id)

        meal_comment = _.find local_comments, (comment)->
          comment.meal_id == model.get('id')

        console.log meal_comment

  DayView
