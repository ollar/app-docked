define [
  'jquery'
  'underscore'
  'backbone'
  'text!templates/common/message.html'
  'models/message'], ($, _, Backbone, MessageTemplate, MessageModel)->
  MessageView = Backbone.View.extend
    tagName: 'li'
    className: 'message'

    initialize: (options)->
      @options = options || {}
      @model = new MessageModel(@options.data)
      @wrapper = $('#message-wrapper')

      @selfDestroy(3000)
      @render()
      @listenTo @model, 'destroy', ->
        @selfDestroy(0)

    events:
      'click': 'selfDestroy'

    template: _.template(MessageTemplate)

    selfDestroy: (duration=0)->
      _.delay =>
        @$el.addClass 'move-out'
        _.delay =>
          @model.destroy()
          @remove()
        , 500
      , duration

    render: ->
      @$el.html @template(@model.toJSON())
      @$el.addClass @model.get 'type'
      @wrapper.append @$el

      @

  MessageView
