define [
  'app'
  'jquery'
  'underscore'
  'marionette'

  'marked'

  'text!templates/meal/comment.html'
  'views/comment/form'
  'models/comment'
], (App, $, _, Mn, marked, Template, CommentFormView, CommentModel) ->

  Comment = Mn.ItemView.extend
    className: 'inner'
    template: _.template Template
    templateHelpers:
      marked: marked
    #   routeName: @_parent.routeName

    initialize: (options)->
      @options = options || {}
      @loggedUser = App.ventFunctions.getLoggedUser()

    ui:
      addComment: '.add-comment'
      removeComment: '.remove-comment'

    events:
      'click @ui.addComment': 'addComment'
      'click @ui.removeComment': 'removeComment'
      'click': (e)-> e.stopPropagation()

    # ================================

    addComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      formView = new CommentFormView
        model: new CommentModel()
        meal_id: @options.meal_id
        user_id: @loggedUser.id
        frontEl: @$el
      @$el.before formView.render().el
      @$el.hide()

    removeComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      commentId = $(e.target).attr 'data-comment-id'
      App.execute 'comment:remove', commentId, @options.meal_id

  Comment
