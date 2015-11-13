define [
  'app'
  'backbone'
  'models/order'
  'localStorage'
], (App, Backbone, OrderModel)->
  OrdersCollection = Backbone.Collection.extend
    model: OrderModel

    url: App.url '/order/'

    parse: (data)->
      data.orders

    initialize: (options)->
      @options = options || {}

    comparator: 'order_date'

  OrdersCollection
