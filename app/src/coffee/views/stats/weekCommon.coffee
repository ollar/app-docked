define [
  'backbone'
  'app'
  'text!templates/stats/week_view_common.html'
  'collections/nextWeekMeals'
  'collections/orders'
  'moment'
  ], (Backbone, App, statsWeekViewCommonTemplate, MealsCollection, OrdersCollection, moment)->
  StatsViewCommon = Backbone.View.extend
    className: 'stats-info week-menu'

    initialize: (options)->
      @options = options || {}

      @collection = new OrdersCollection()
      @mealsCollection = new MealsCollection()

      @collection.url = '/stats/week'
      @collection.fetch
        success: =>
          @mealsCollection.fetch
            success: =>
              @renderData()
            error: (collection, response, options)=>
              App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}


    itemTemplate: _.template(statsWeekViewCommonTemplate)

    renderData: ->
      orders = _.groupBy @collection.models, (model)-> model.get 'order_date'

      _.each @mealsCollection.models, (_meals)=>
        _orders = _.groupBy orders[_.first(_meals.toJSON()).order_date], (model)->
          model.get('user').real_name
        @$el.append @itemTemplate
          date: moment(_.first(_meals.toJSON()).order_date).format('dddd, MMMM Do'),
          meals: _meals.toJSON(), orders: _orders

      @

  StatsViewCommon
