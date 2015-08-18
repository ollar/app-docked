define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/order/view.html'
  'moment'
  'behaviors/select'
  'translate'
  ], ($, _, App, Mn, orderViewTemplate, moment, Select, translate)->
  OrderView = Mn.ItemView.extend
    className: 'order pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @listenTo App.vent, 'order:meal_'+@model.get('meal_id')+':remove:success', ->
        @remove()

    events:
      'click .delete': -> App.vent.trigger 'order:remove', @model.get('id'), @model.get('user_id'), @model.get('meal_id')

    template: _.template(orderViewTemplate)
    templateHelpers: ->
      moment: moment
      t: translate

    behaviors:
      Select:
        behaviorClass: Select

    onRender: ->
      @$el.attr 'data-order-id', @model.get('id')

      @

  OrderView
