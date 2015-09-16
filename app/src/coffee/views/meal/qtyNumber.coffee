define [
  'jquery'
  'underscore'
  'marionette'

  'text!templates/meal/qty_el.html'
], ($, _, Mn, Template) ->

  QtyNum = Mn.ItemView.extend
    tagName: 'span'
    className: 'ordered-qty'
    template: _.template Template

    initialize: ->
      # console.log @model
      # @model.on 'change:ordered', =>
      #   @render()

  QtyNum
