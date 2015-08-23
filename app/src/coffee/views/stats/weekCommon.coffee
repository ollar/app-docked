define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/stats/week_view_common.html'
  'collections/nextWeekMeals'
  'collections/orders'
  'moment'
  ], ($, _, Backbone, App, statsWeekViewCommonTemplate, MealsCollection, OrdersCollection, moment)->
  StatsViewCommon = Backbone.View.extend
    className: 'stats-info week-menu'

    initialize: (options)->
      @options = options || {}

      @collection = new OrdersCollection()
      @collection.url = '/stats/week'
      @collection.fetch()

      @mealsCollection = new MealsCollection()
      @mealsCollection.fetch
        success: =>
          @renderData()
        error: (collection, response, options)=>
          App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}


    itemTemplate: _.template(statsWeekViewCommonTemplate)

    renderData: ->
      console.log @collection
      meals = _.groupBy @mealsCollection.models, (model)-> model.get 'order_date'
      orders = _.groupBy @collection.models, (model)-> model.get 'order_date'

      _.each meals, (_meals, key)=>
        _orders = _.groupBy orders[key], (model)-> model.get('user').real_name
        @$el.append @itemTemplate( {date: moment(key).format('dddd, MMMM Do'), meals: _meals, orders: _orders} )

      @

  StatsViewCommon
