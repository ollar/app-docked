define [
  'app'
  'marionette'
  'collections/orders'
  'views/order/view'
  'views/common/empty'
  'behaviors/infinite_load'
  ], (App, Mn, OrdersCollection, OrderView, EmptyView, Infinite)->
  OrdersListView = Mn.CollectionView.extend
    className: 'menu-wrapper items-list'

    childView: OrderView

    collection: new OrdersCollection()

    emptyView: EmptyView

    behaviors:
      Infinite:
        behaviorClass: Infinite

    initialize: ->
      @collection.fetch()

  OrdersListView
