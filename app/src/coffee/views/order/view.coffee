define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'text!templates/order/view.html'
  # 'channel'
  'moment'], ($, _, Backbone, App, Mn, orderViewTemplate, moment)->
  OrderView = Mn.ItemView.extend
    className: 'order pure-menu-item'

    # initialize: (options)->
    #   @options = options || {}
    #   @selected = no
    #
    #   @listenTo channel, 'order:meal_'+@model.get('meal_id')+':remove:success', ->
    #     @remove()



    events:
      'click': 'selectToggle'
      'click .delete': -> channel.trigger 'order:remove', @model.get('id'), @model.get('user_id'), @model.get('meal_id')

    template: _.template(orderViewTemplate)
    templateHelpers: ->
      moment: moment

    selectToggle: ->
      @selected = !@selected
      @$el.toggleClass 'selected', @selected

    onRender: ->
      @$el.attr 'data-order-id', @model.get('id')
      @$el.toggleClass 'selected', @selected

      @

  OrderView
