define [
  'backbone'
  'models/order'
  'localStorage'], (Backbone, OrderModel)->
  OrdersCollection = Backbone.Collection.extend
    model: OrderModel

    url: '/order/'

    parse: (data)->
      data.orders

    initialize: (options)->
      @options = options || {}

    comparator: 'order_date'

  OrdersCollection
