define [
  'jquery'
  'underscore'
  'backbone'
  'text!templates/stats/month_view_common.html'
  'text!templates/stats/total.html'
  'text!templates/stats/month_common_item.html'
  'moment'
  'translate'], ($, _, Backbone, MonthStatTemplate, TotalTemplate, MonthCommonItemTemplate, moment, translate) ->

  MonthStatCommonView = Backbone.View.extend
    className: 'common-month-stat'
    initialize: (options)->
      @options = options || {}
      @userStat = _.groupBy @collection.models, (model) -> model.get('user').real_name
      @thisMonth = moment(_.now()).format('MMMM YYYY')

      @$el.html @template({thisMonth: @thisMonth})
      @$list = @$el.find('.stats-menu')

      @render()

    template: _.template(MonthStatTemplate)
    itemTemplate: _.template(MonthCommonItemTemplate)
    totalTemplate: _.template(TotalTemplate)

    render: ->
      res_total = 0
      _.each @userStat, (_orders, _key)=>
        total = 0
        _.each _orders, (_order)->
          total += _order.get('meal').price * _order.get('quantity')
        res_total += total
        @$list.append @itemTemplate({name: _key, user_id: _orders.pop().get('user_id'), total: total})

      @options.content.html @$el

  MonthStatCommonView
