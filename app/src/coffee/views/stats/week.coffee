define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/stats/week_view.html'
  'text!templates/stats/total.html'
  'text!templates/common/empty.html'
  'text!templates/common/send_email_button.html'
  'moment'
  'translate'
  'channel'], ($, _, Backbone, App, statsWeekViewTemplate, TotalTemplate, EmptyTemplate, SendEmailButton, moment, translate, channel)->
  StatsView = Backbone.View.extend
    className: 'stats-info week-menu'

    initialize: (options)->
      @options = options || {}

      @render()

    itemTemplate: _.template(statsWeekViewTemplate)
    resTemplate: _.template(TotalTemplate)
    sendEmailTemplate: _.template(SendEmailButton)

    events:
      'click .send-email': 'sendEmail'

    sendEmail: ->
      user = _.first(@collection.models).get('user')

      channel.trigger 'email:send', {
        html: @$el.html()
        toemail: user.email
        toname: user.real_name
        subject: user.real_name+' Week Order Status!'
      }, ->
        channel.trigger 'message', {type: 'message', text: 'Orders status sent to user <b>'+user.real_name+'</b>'}
      , ->
        channel.trigger 'message', {type: 'message', text: 'Oops smthing went wrong'}


    render: ->
      orders = _.groupBy @collection.models, (model)-> model.get 'order_date'

      res_price = 0

      _.each orders, (_orders, key)=>
        @$el.append @itemTemplate( {date: moment(key).format('dddd, MMMM Do'), orders: _orders} )

        _.each _orders, (_order)->
          res_price += _order.get('meal').price * _order.get('quantity')

      if res_price
        @$el.append _.template(@resTemplate({price: res_price, t: translate}))
        if channel.getLoggedUser().id == 1
          @$el.append _.template(@sendEmailTemplate({t: translate}))
      else
        @$el.html _.template(EmptyTemplate)({t: translate})

      @options.content.html @$el

  StatsView
