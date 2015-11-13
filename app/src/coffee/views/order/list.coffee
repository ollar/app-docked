define [
  'app'
  'marionette'
  'collections/orders'
  'views/order/view'
  'views/common/empty'
  'translate'
  'behaviors/infinite_load'
  ], (App, Mn, OrdersCollection, OrderView, EmptyView, translate, Infinite)->
  OrdersListView = Mn.CollectionView.extend
    className: 'menu-wrapper items-list'
    templateHelpers: ->
      t: translate

    childView: OrderView

    collection: new OrdersCollection()

    emptyView: EmptyView

    behaviors:
      Infinite:
        behaviorClass: Infinite

    initialize: ->
      @collection.fetch()

  OrdersListView
