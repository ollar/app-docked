define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'text!templates/order/view.html'
  'moment'
  'behaviors/select'
  ], ($, _, Backbone, App, Mn, orderViewTemplate, moment, Select)->
  OrderView = Mn.ItemView.extend
    className: 'order pure-menu-item'

    # initialize: (options)->
    #   @options = options || {}
    #   @selected = no
    #
    #   @listenTo channel, 'order:meal_'+@model.get('meal_id')+':remove:success', ->
    #     @remove()



    events:
      'click .delete': -> App.vent.trigger 'order:remove', @model.get('id'), @model.get('user_id'), @model.get('meal_id')

    template: _.template(orderViewTemplate)
    templateHelpers: ->
      moment: moment

    behaviors:
      Select:
        behaviorClass: Select

    onRender: ->
      @$el.attr 'data-order-id', @model.get('id')
      @$el.toggleClass 'selected', @selected

      @

  OrderView
