define [
  'jquery'
  'underscore'
  'backbone'
  'text!templates/stats/month_view_common.html'
  'text!templates/stats/total.html'
  'text!templates/stats/month_common_item.html'
  'moment'
  'translate'
  'collections/orders'
  ], ($, _, Backbone, MonthStatTemplate, TotalTemplate, MonthCommonItemTemplate, moment, translate, OrdersCollection) ->

  MonthStatCommonView = Backbone.View.extend
    className: 'common-month-stat'
    initialize: (options)->
      @options = options || {}
      @thisMonth = moment(_.now()).format('MMMM YYYY')

      @$el.html @template({thisMonth: @thisMonth})
      @$list = @$el.find('.stats-menu')

      @collection = new OrdersCollection()
      @collection.url = '/stats/month?full'

      @collection.fetch
        success: (collection, response, options)=>
          @userStat = _.groupBy collection.models, (model) ->
            if model.get('user') then model.get('user').real_name else 'deleted'
          @renderData()
        error: (collection, response, options)=>
          App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}


    template: _.template(MonthStatTemplate)
    itemTemplate: _.template(MonthCommonItemTemplate)
    totalTemplate: _.template(TotalTemplate)

    renderData: ->
      res_total = 0
      _.each @userStat, (_orders, _key)=>
        total = 0
        _.each _orders, (_order)->
          if _order.get('meal')
            total += _order.get('meal').price * _order.get('quantity')
        res_total += total
        @$list.append @itemTemplate({name: _key, user_id: _orders.pop().get('user_id'), total: total})

      @

  MonthStatCommonView
