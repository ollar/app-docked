define [
  'marionette'

  'text!templates/meal/qty.html'
], (Mn, Template) ->

  Qty = Mn.ItemView.extend
    template: _.template Template
    className: 'flex-wrapper pure-form'

    initialize: ->
      @model.on 'change:qty', (model)=>
        @$('.qty input').attr 'value', model.get('qty')

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
      return if @model.get('qty') <= 1
      @model.set('qty', @model.get('qty')-1)

    increaseQty: ->
      @model.set('qty',  @model.get('qty')+1)

  Qty
