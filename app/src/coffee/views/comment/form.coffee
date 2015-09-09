define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'text!templates/comment/form.html'
  'translate'
], (App, $, _, Mn, FormTemplate, translate) ->

  CommentForm = Mn.ItemView.extend

    className: 'commend-add'

    events:
      'click': (e)-> e.stopPropagation()
      'submit #comment_form': 'commentSubmit'
      'click .cancel': 'cancel'

    template: _.template FormTemplate
    templateHelpers:
      t:translate

    initialize: (options)->
      @options = options || {}
      @meal_id = options.meal_id
      @user_id = options.user_id

    commentSubmit: (e)->
      e.preventDefault()
      formData = $(e.target).serializeObject()
      App.execute 'comment:create', _.extend formData,
        meal_id: @meal_id
        user_id: @user_id

    cancel: ->
      @options.frontEl.show()
      @destroy()
