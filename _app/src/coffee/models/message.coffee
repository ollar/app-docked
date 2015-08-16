define [
  'jquery'
  'underscore'
  'backbone'], ($, _, Backbone)->
  MessageModel = Backbone.Model.extend

    defaults: ->
      type: 'info'
      text: ''

  MessageModel
