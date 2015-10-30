define ['backbone'], (Backbone)->
  MessageModel = Backbone.Model.extend

    defaults: ->
      type: 'info'
      text: ''

  MessageModel
