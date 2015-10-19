define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/stats/month_view.html'
  'text!templates/stats/total.html'
  'text!templates/stats/pager.html'
  'text!templates/common/empty.html'
  'text!templates/common/send_email_button.html'
  'moment'
  'translate'
  'collections/orders'
  ], ($, _, Backbone, App, UserStatsMonthTemplate, TotalTemplate, PagerTemplate, EmptyTemplate, SendEmailButton, moment, translate, OrdersCollection)->
    MonthStatsView = Backbone.View.extend
      className: 'stats-info month-stats'
      initialize: (options)->
        @options = options || {}
        @user_id = @options.user_id

        @collection = new OrdersCollection()
        if @user_id
          @collection.url = '/stats/month?user_id=' + @user_id
        else
          @collection.url = '/stats/month?user_id=' + $.cookie('id')

        if @options.month
          @collection.url += '&month_number=' + @options.month

        @thisMonth = moment(_.now()).month()
        @prevMonth = @options.month-1 || @thisMonth
        @nextMonth = @options.month+1 || @thisMonth+2

        if @nextMonth-2 >= @thisMonth
          @nextMonth = null

        @collection.fetch
          success: =>
            @renderData()
          error: (collection, response, options)=>
            App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}


      template: _.template(UserStatsMonthTemplate)
      resTemplate: _.template(TotalTemplate)
      pagerTemplate: _.template(PagerTemplate)
      sendEmailTemplate: _.template(SendEmailButton)

      events:
        'click .send-email': 'sendEmail'
        'click .pager a': 'pagerClicked'

      generatePagerUrl: (user_id, month)->
        _.template('/stats/month<% if (user_id){ %>/u<%= user_id %><% };%><% if (month){ %>/m<%= month %><% };%>')({user_id: user_id, month: month})

      sendEmail: ->
        user = _.first(@collection.models).get('user')

        App.execute 'email:send', {
          html: @$el.html()
          toemail: user.email
          toname: user.real_name
          subject: user.real_name+' Month Order Status!'
        }, ->
          App.execute 'message', {type: 'message', text: 'Orders status sent to user <b>'+user.real_name+'</b>'}
        , ->
          App.execute 'message', {type: 'message', text: 'Oops smthing went wrong'}

      pagerClicked: (e)->
        e.preventDefault()
        App.navigate($(e.target).attr('href'))

      renderData: ->
        orders = _.groupBy @collection.models, (model)-> model.get 'order_date'

        res_price = 0

        _.each orders, (_orders, _date)=>
          @$el.append @template({date: moment(_date).format('dddd, MMMM Do'), orders: _orders} )
          _.each _orders, (_order)=>
            if _order.get('meal')
              res_price += _order.get('meal').price * _order.get('quantity')

        if res_price
          @$el.append _.template(@resTemplate({price: res_price, t: translate}))
          if App.ventFunctions.getLoggedUser().id == 1
            @$el.append _.template(@sendEmailTemplate({t: translate}))
        else
          @$el.html _.template(EmptyTemplate)({t: translate})

        @$el.prepend @pagerTemplate({prev: @generatePagerUrl(@user_id, @prevMonth), next: @generatePagerUrl(@user_id, @nextMonth), t: translate})
        @$el.append @pagerTemplate({prev: @generatePagerUrl(@user_id, @prevMonth), next: @generatePagerUrl(@user_id, @nextMonth), t: translate})

        @

    MonthStatsView
