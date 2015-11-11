define [
  'app'
  'backbone'
], (App, Backbone)->
  MessageModel = Backbone.Model.extend

    defaults: ->
      type: 'info'
      text: ''

  MessageModel
