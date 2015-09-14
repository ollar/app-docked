define [
  'jquery'
  'underscore'
  'marionette'

  'text!templates/meal/qty.html'
], ($, _, Mn, Template) ->

  Qty = Mn.ItemView.extend
    template: _.template Template
    className: 'table-wrapper pure-form'

    initialize: ->
      @numberModel = new Backbone.Model
        count: 1

      @numberModel.on 'change', (model)=>
        @ui.qtyInput.attr 'value', model.get('count')

    ui:
      qtyInput: '.qty input'
      decrease: '.decrease'
      increase: '.increase'

    events:
      'click': (e)-> e.stopPropagation()
      'click @ui.decrease': 'decreaseQty'
      'click @ui.increase': 'increaseQty'

    # ================================

    decreaseQty: ->
      return if @numberModel.get('count') <= 1
      @numberModel.set('count', @numberModel.get('count')-1)

    increaseQty: ->
      @numberModel.set('count',  @numberModel.get('count')+1)

  Qty
