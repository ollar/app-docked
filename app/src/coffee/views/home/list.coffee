define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'views/meal/view'
  'views/home/day'
  'text!templates/home/view.html'
  'collections/nextWeekMeals'
  'translate'
  ], ($, _, App, Mn, MealView, DayView, HomeTemplate, NWMealsCollection, translate)->
  HomeView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper'

    collection: new NWMealsCollection()
    childView: DayView
    childViewContainer: '.pure-menu-list'

    template: _.template HomeTemplate
    templateHelpers: ->
      t: translate

    ui:
      footer: '.buttons-wrapper'

    events:
      'click .go': 'makeOrder'

    initialize: ->
      @collection.fetch()

    # renderData: ->
    #   loggedUser = channel.getLoggedUser()
    #   local_orders = _.groupBy loggedUser.get('orders'), (order)->order.order_date
    #
    #   @collection.each (model)->
    #     _order_date = model.get('order_date')
    #
    #     view = new @view({model: model})
    #     @subviews.push(view)
    #     view.$el.attr 'data-order-date', model.get('order_date')
    #     @$list.append view.render().el
    #
    #     if _.contains(_.pluck(local_orders[_order_date], 'meal_id'), model.get('id'))
    #       match = _.find local_orders[_order_date], (order)-> order.meal_id == model.get('id')
    #       view.orderSuccess(match.quantity, match.id)
    #
    #   , @
    #
    #

    makeOrder: ->
      selected = _.where @subviews, {selected: yes}

      _.each selected, (mealView)->
        _qty = mealView.$el.find('.qty input').val()
        mealModel = mealView.model

        App.vent.trigger 'order:create',
          id: $.cookie 'id'
          qty: _qty
          meal_id: mealModel.get 'id'
          order_date: mealModel.get 'order_date'
        , @

  HomeView
