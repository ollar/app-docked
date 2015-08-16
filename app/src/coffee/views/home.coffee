define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'views/meal/view'
  'text!templates/home/view.html'
  'collections/nextWeekMeals'
  # 'channel'
  'translate'
  ], ($, _, Backbone, App, Mn, MealView, HomeTemplate, NWMealsCollection, translate)->
  HomeView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper'

    collection: new NWMealsCollection()
    childView: MealView
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
    #   $('.day-0').wrapAll('<div class="weekday monday" />')
    #   $('.day-1').wrapAll('<div class="weekday tuesday" />')
    #   $('.day-2').wrapAll('<div class="weekday wednesday" />')
    #   $('.day-3').wrapAll('<div class="weekday thursday" />')
    #   $('.day-4').wrapAll('<div class="weekday friday" />')
    #
    #   @

    onRender: ->
      # _.delay =>
      #   @children.each (child)->
      #     child.$el.attr 'data-order-date', child.model.get('order_date')
      # , 1000

      # TODO refactor this shit too
      $('.day-0').wrapAll('<div class="weekday monday" />')
      $('.day-1').wrapAll('<div class="weekday tuesday" />')
      $('.day-2').wrapAll('<div class="weekday wednesday" />')
      $('.day-3').wrapAll('<div class="weekday thursday" />')
      $('.day-4').wrapAll('<div class="weekday friday" />')

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

  HomeView
