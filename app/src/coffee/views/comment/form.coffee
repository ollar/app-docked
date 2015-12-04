define [
  'app'
  'marionette'

  'text!templates/comment/form.html'
], (App, Mn, FormTemplate) ->

  CommentForm = Mn.ItemView.extend

    className: 'commend-add inner'

    events:
      'click': (e)-> e.stopPropagation()
      'submit #comment_form': 'commentSubmit'
      'click .cancel': 'cancel'

    template: _.template FormTemplate

    initialize: ->
      @meal_id = @options.meal_id
      @user_id = @options.user_id

    commentSubmit: (e)->
      e.preventDefault()
      formData = $(e.target).serializeObject()
      App.execute 'comment:create', _.extend(formData, {
        meal_id: @meal_id
        user_id: @user_id
      }), @options.mealView

      @options.mealView.trigger 'busy:start'
      @options.mealView.on 'comment:create:success', @cancel, @

    cancel: ->
      @options.frontEl.show()
      @destroy()
