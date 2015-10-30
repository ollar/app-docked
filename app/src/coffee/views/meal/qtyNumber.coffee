define [
  'marionette'

  'text!templates/meal/qty_el.html'
], (Mn, Template) ->

  QtyNum = Mn.ItemView.extend
    tagName: 'span'
    className: 'ordered-qty'
    template: _.template Template

    onBeforeShow: ->
      if !@model.get('ordered')
        @$el.hide()

  QtyNum
