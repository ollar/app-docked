define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/stats/week_view_common.html'
  'collections/nextWeekMeals'
  'moment'
  ], ($, _, Backbone, App, statsWeekViewCommonTemplate, MealsCollection, moment)->
  StatsViewCommon = Backbone.View.extend
    className: 'stats-info week-menu'

    initialize: (options)->
      @options = options || {}

      @mealsCollection = new MealsCollection()
      @mealsCollection.fetch
        success: =>
          @render()

    itemTemplate: _.template(statsWeekViewCommonTemplate)

    render: ->
      meals = _.groupBy @mealsCollection.models, (model)-> model.get 'order_date'
      orders = _.groupBy @collection.models, (model)-> model.get 'order_date'

      _.each meals, (_meals, key)=>
        _orders = _.groupBy orders[key], (model)-> model.get('user').real_name
        @$el.append @itemTemplate( {date: moment(key).format('dddd, MMMM Do'), meals: _meals, orders: _orders} )

      @options.content.html @$el

  StatsViewCommon
