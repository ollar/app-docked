define [
  'jquery'
  'underscore'
  'marionette'

  'text!templates/meal/qty.html'
], ($, _, Mn, Template) ->

  Qty = Mn.ItemView.extend
    template: _.template Template
    className: 'table-wrapper pure-form'

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
      @qtyInput = @ui.qtyInput
      if @qtyInput.val() > 1 then @qtyInput.attr 'value', +@qtyInput.val() - 1 else return

    increaseQty: ->
      @qtyInput = @ui.qtyInput
      @qtyInput.attr 'value', +@qtyInput.val() + 1

  Qty
