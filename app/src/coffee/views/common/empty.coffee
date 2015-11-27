define [
  'marionette'
  'text!templates/common/empty.html'
], (Mn, Template)->
  EmptyView = Mn.ItemView.extend
    template: _.template Template


  EmptyView
