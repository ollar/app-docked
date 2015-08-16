define [
  'marionette'
  'text!templates/common/empty.html'
  'translate'
], (Mn, Template, translate)->
  EmptyView = Mn.ItemView.extend
    template: _.template Template
    templateHelpers: ->
      t: translate


  EmptyView
