define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/order/view.html'
  'moment'
  'behaviors/select'
  'behaviors/remove'
  'behaviors/setAttrs'
  'translate'
  ], ($, _, App, Mn, orderViewTemplate, moment, Select, Remove, SetAttrs, translate)->
  OrderView = Mn.ItemView.extend
    className: 'order pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @listenTo App.vent, 'order:meal_'+@model.get('meal_id')+':remove:success', ->
        @remove()

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
      SetAttrs:
        behaviorClass: SetAttrs

  OrderView
