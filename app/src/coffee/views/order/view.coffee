define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/order/view.html'
  'moment'
  'behaviors/select'
  'behaviors/remove'
  'translate'
  ], ($, _, App, Mn, orderViewTemplate, moment, Select, Remove, translate)->
  OrderView = Mn.ItemView.extend
    className: 'order pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @listenTo App.vent, 'order:meal_'+@model.get('meal_id')+':remove:success', ->
        @remove()

    # events:
    #   'click .delete': -> App.execute 'order:remove', @model.get('id'), @model.get('user_id'), @model.get('meal_id')

    ui:
      remove: '.delete'

    template: _.template(orderViewTemplate)
    templateHelpers: ->
      moment: moment
      t: translate

    behaviors:
      Select:
        behaviorClass: Select
      Remove:
        behaviorClass: Remove
        message: translate 'order removed'

    onRender: ->
      @$el.attr 'data-order-id', @model.get('id')

      @

  OrderView
