define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'collections/orders'
  'views/order/view'
  'views/common/empty'
  'text!templates/order/list_view.html'
  'translate'], ($, _, Backbone, App, Mn, OrdersCollection, OrderView, EmptyView, OrdersListTemplate, translate)->
  OrdersListView = Mn.CompositeView.extend
    className: 'pure-menu menu-wrapper'
    template: _.template OrdersListTemplate
    templateHelpers: ->
      t: translate

    childView: OrderView
    childViewContainer: ".pure-menu-list"

    collection: new OrdersCollection()

    emptyView: EmptyView

    initialize: ->
      @collection.fetch()

  OrdersListView
