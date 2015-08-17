define [
  'jquery'
  'underscore'
  'backbone'

  'text!templates/comment/form.html'
  'translate'
], ($, _, Backbone, FormTemplate, translate) ->

  class View extends Backbone.View

    className: 'commend-add'

    events:
      'submit #comment_form': 'commentSubmit'

    template: _.template(FormTemplate)

    initialize: (options)->
      super
      @options = options || {}
      @meal_id = options.meal_id
      @user_id = options.user_id

    commentSubmit: (e)->
      e.preventDefault()
      formData = $(e.target).serializeObject()
      channel.trigger 'comment:create', _.extend formData,
        meal_id: @meal_id
        user_id: @user_id


    render: ->
      @$el.html @template(_.extend(@model.toJSON(), {t:translate}))
      @
