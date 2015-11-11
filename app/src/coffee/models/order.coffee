define [
  'app'
  'backbone'
], (App, Backbone)->
  OrderModel = Backbone.Model.extend
    urlRoot: App.url '/order/'

    defaults: ->
      user_id: ''
      meal_id: ''
      quantity: 1
      order_date: ''

  OrderModel
