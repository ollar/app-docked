define [
  'app'
  'marionette'
  'text!templates/meal/view.html'
  'marked'
  'behaviors/select'
  'behaviors/remove'
  'behaviors/edit'
  'behaviors/setAttrs'
  'behaviors/loading'

  'views/meal/form'
  'views/meal/comment'

  'models/meal'

  'collections/comments'
  'views/comment/simple_list'
  ], (App, Mn, Template, marked, Select, Remove, Edit, SetAttrs, Loading, MealFormView, CommentView, MealModel, CommentsCollection, SimpleCommentsListView)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    regions: ->
      comments: '.comments'

    template: _.template Template
    templateHelpers: ->
      marked: marked

    events:
      'click .toggle-enabled': 'toggleEnabled'
      'click .show-comments': 'showComments'
      'click .hide-comments': 'hideComments'

    behaviors:
      Select:
        behaviorClass: Select
      Remove:
        behaviorClass: Remove
        message: _('meal removed')
      Edit:
        behaviorClass: Edit
        formView: MealFormView
      SetAttrs:
        behaviorClass: SetAttrs
        attrs:
          'day': 'day_linked'
          'category': 'category'
          'order-date': 'order_date'
      Loading:
        behaviorClass: Loading

    # ==========================================================================

    toggleEnabled: ->
      @model.save {'enabled': !@model.get('enabled')},
        success: =>
          @select = yes
          @$el.toggleClass 'disabled', !@model.get('enabled')
          @render()

    # ==================================

    showComments: (e)->
      @trigger('busy:start')
      e.stopPropagation()

      comments = new CommentsCollection()
      comments.url = '/comment/meal/' + @model.id

      comments.fetch
        success: (collection, response)=>
          _.defer =>
            commentsList = new SimpleCommentsListView
              collection: collection
              origin: 'meals'
            @comments.show(commentsList)
            $(e.target).text(_('hide comments').t())
              .removeClass('show-comments')
              .addClass('hide-comments')
            @trigger('busy:stop')

    hideComments: (e)->
      e.stopPropagation()
      @comments.empty()
      $(e.target).text(_('show comments').t())
        .addClass('show-comments')
        .removeClass('hide-comments')

  MealView
