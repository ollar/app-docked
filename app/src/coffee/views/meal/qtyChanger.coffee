define [
  'jquery'
  'underscore'
  'marionette'

  'text!templates/meal/qty.html'

  'models/mealQty'
], ($, _, Mn, Template, QtyModel) ->

  Qty = Mn.ItemView.extend
    template: _.template Template
    className: 'table-wrapper pure-form'

    initialize: ->
      console.log 'iniii'
      @model.on 'change', (model)=>
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
      return if @model.get('count') <= 1
      @model.set('count', @model.get('count')-1)

    increaseQty: ->
      @model.set('count',  @model.get('count')+1)

  Qty
