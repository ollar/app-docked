define [
  'app'
  'marionette'
  'text!templates/user/view.html'
  'behaviors/select'
  'behaviors/remove'
  'behaviors/edit'
  'behaviors/setAttrs'
  'behaviors/loading'
  'behaviors/link'

  'collections/comments'

  'views/user/form'
  'views/comment/simple_list'
  ], (App, Mn, Template, Select, Remove, Edit, SetAttrs, Loading, Link, CommentsCollection, UserFormView,  SimpleCommentsListView)->
  UserView = Mn.LayoutView.extend
    className: 'user pure-menu-item'

    regions:
      commentsRegion: '.comments'

    initialize: (options)->
      @options = options || {}
      @on 'me:clicked', ->
        @hideComments.call(@) if !@select

    template: _.template Template

    ui:
      remove: '.remove'
      edit: '.edit'
      showComments: '.show-comments'
      hideComments: '.hide-comments'

    events:
      'click .stats-menu a': (e)-> e.stopPropagation()
      'click @ui.showComments': 'fetchComments'
      'click @ui.hideComments': 'hideComments'

    behaviors:
      Select:
        behaviorClass: Select
      Remove:
        behaviorClass: Remove
        # text: 'user "<i>'+@model.get('real_name')+'</i>" removed'
        message: _.t 'user removed'
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
        url: App.url '/comment/user/' + @model.id
      comments = new Comments()

      comments.fetch
        success: (collection, response)=>
          _.defer =>
            commentsList = new SimpleCommentsListView
              collection: collection
              origin: 'users'
            @commentsRegion.show(commentsList)
            @ui.showComments.text(_.t('hide comments'))
              .removeClass('show-comments')
              .addClass('hide-comments')
            @trigger('busy:stop')

    hideComments: (e)->
      e.stopPropagation() if e
      @commentsRegion.empty()
      @ui.showComments.text(_.t('show comments'))
        .addClass('show-comments')
        .removeClass('hide-comments')

  UserView
