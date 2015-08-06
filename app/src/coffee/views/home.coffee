define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'views/meal/view'
  'text!templates/home/view.html'
  'views/list'
  'channel'], ($, _, Backbone, App, MealView, HomeTemplate, ListView, channel)->
  MealsListView = ListView.extend
    initialize: ->
      @listTemplate = HomeTemplate
      @view = MealView
      @addView = no

      ListView.prototype.initialize.apply(this, arguments)

      @$list = @$el.find('.pure-menu-list')
      @footer = @$el.find('.buttons-wrapper')

      @renderData()

    events: _.extend ListView.prototype.events, {'click .go': 'makeOrder'}

    renderData: ->
      loggedUser = channel.getLoggedUser()
      local_orders = _.groupBy loggedUser.get('orders'), (order)->order.order_date

      @collection.each (model)->
        _order_date = model.get('order_date')

        view = new @view({model: model})
        @subviews.push(view)
        view.$el.attr 'data-order-date', model.get('order_date')
        @$list.append view.render().el

        if _.contains(_.pluck(local_orders[_order_date], 'meal_id'), model.get('id'))
          match = _.find local_orders[_order_date], (order)-> order.meal_id == model.get('id')
          view.orderSuccess(match.quantity, match.id)

      , @

      # TODO refactor this shit too

      $('.day-0').wrapAll('<div class="weekday monday" />')
      $('.day-1').wrapAll('<div class="weekday tuesday" />')
      $('.day-2').wrapAll('<div class="weekday wednesday" />')
      $('.day-3').wrapAll('<div class="weekday thursday" />')
      $('.day-4').wrapAll('<div class="weekday friday" />')

      @

    makeOrder: ->
      selected = _.where @subviews, {selected: yes}

      _.each selected, (mealView)->
        _qty = mealView.$el.find('.qty input').val()
        mealModel = mealView.model

        channel.trigger 'order:create',
          id: $.cookie 'id'
          qty: _qty
          meal_id: mealModel.get 'id'
          order_date: mealModel.get 'order_date'
        , @

  MealsListView
