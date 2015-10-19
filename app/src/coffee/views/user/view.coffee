define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/user/view.html'
  'translate'
  'behaviors/select'
  'behaviors/remove'
  'behaviors/edit'
  'behaviors/setAttrs'
  'behaviors/loading'
  'behaviors/link'

  'collections/comments'

  'views/user/form'
  'views/comment/simple_list'
  ], ($, _, App, Mn, Template, translate, Select, Remove, Edit, SetAttrs, Loading, Link, CommentsCollection, UserFormView,  SimpleCommentsListView)->
  UserView = Mn.LayoutView.extend
    className: 'user pure-menu-item'

    regions:
      commentsRegion: '.comments-wrapper'

    initialize: (options)->
      @options = options || {}

    template: _.template Template
    templateHelpers: ->
      t: translate

    ui:
      remove: '.remove'
      edit: '.edit'

    events:
      'click .stats-menu a': (e)-> e.stopPropagation()
      'click .show-comments': 'fetchComments'
      'click .hide-comments': 'hideComments'

    behaviors:
      Select:
        behaviorClass: Select
      Remove:
        behaviorClass: Remove
        # text: 'user "<i>'+@model.get('real_name')+'</i>" removed'
        message: translate 'user removed'
      Edit:
        behaviorClass: Edit
        formView: UserFormView
      SetAttrs:
        behaviorClass: SetAttrs
      Loading:
        behaviorClass: Loading
      Link:
        behaviorClass: Link

    fetchComments: (e)->
      @trigger('busy:start')
      e.stopPropagation()

      Comments = CommentsCollection.extend
        url: '/comment/user/' + @model.id
      comments = new Comments()

      comments.fetch
        success: (collection, response)=>
          _.defer =>
            commentsList = new SimpleCommentsListView
              collection: collection
              origin: 'users'
            @commentsRegion.show(commentsList)
            $(e.target).text(translate('hide comments'))
              .removeClass('show-comments')
              .addClass('hide-comments')
            @trigger('busy:stop')

    hideComments: (e)->
      e.stopPropagation()
      @commentsRegion.empty()
      $(e.target).text(translate('show comments'))
        .addClass('show-comments')
        .removeClass('hide-comments')

  UserView
