define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'collections/orders'
  'views/order/view'
  'text!templates/order/list_view.html'
  'views/list'], ($, _, Backbone, App, OrdersCollection, OrderView, OrdersListTemplate, ListView)->
  OrdersListView = ListView.extend
    initialize: ->
      @listTemplate = OrdersListTemplate
      @view = OrderView

      ListView.prototype.initialize.apply(this, arguments)

      @$list = @$el.find('.pure-menu-list')

      @renderData()

  OrdersListView
