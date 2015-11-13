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

    ui:
      showComments: '.show-comments'
      hideComments: '.hide-comments'

    events:
      'click .toggle-enabled': 'toggleEnabled'
      'click @ui.showComments': 'showComments'
      'click @ui.hideComments': 'hideComments'

    initialize: ->
      @on 'me:clicked', ->
        @hideComments.call(@) if !@select

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
      comments.url = App.url '/comment/meal/' + @model.id

      comments.fetch
        success: (collection, response)=>
          _.defer =>
            commentsList = new SimpleCommentsListView
              collection: collection
              origin: 'meals'
            @comments.show(commentsList)
            @ui.showComments.text(_('hide comments').t())
              .removeClass('show-comments')
              .addClass('hide-comments')
            @trigger('busy:stop')

    hideComments: (e)->
      e.stopPropagation() if e
      @comments.empty()
      @ui.showComments.text(_('show comments').t())
        .addClass('show-comments')
        .removeClass('hide-comments')

  MealView
