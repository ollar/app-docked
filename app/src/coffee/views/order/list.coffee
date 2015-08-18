define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'collections/orders'
  'views/order/view'
  'views/common/empty'
  'text!templates/order/list_view.html'
  'translate'
  'behaviors/sort'
  ], ($, _, App, Mn, OrdersCollection, OrderView, EmptyView, OrdersListTemplate, translate, Sort)->
  OrdersListView = Mn.CompositeView.extend
    className: 'pure-menu menu-wrapper'
    template: _.template OrdersListTemplate
    templateHelpers: ->
      t: translate

    childView: OrderView
    childViewContainer: ".pure-menu-list"

    collection: new OrdersCollection()

    emptyView: EmptyView

    behaviors:
      Sort:
        behaviorClass: Sort

    initialize: ->
      @collection.fetch()

  OrdersListView
