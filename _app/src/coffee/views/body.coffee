define [
  'jquery'
  'underscore'
  'backbone'
  'channel'
], ($, _, Backbone, channel) ->

  class View extends Backbone.View

    el: "body"

    events:
      "click": "bodyClick"

    initialize: (args...)->
      super
