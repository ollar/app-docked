define [
  'backbone'
], (Backbone)->
  QtyModel = Backbone.Model.extend
    defaults:
      count: 1
      ordered: no

  QtyModel
