define [
  'jquery'
  'underscore'
  'backbone'], ($, _, Backbone)->
  OrderModel = Backbone.Model.extend
    urlRoot: '/order/'

    defaults: ->
      user_id: ''
      meal_id: ''
      quantity: 1
      order_date: ''

  OrderModel
