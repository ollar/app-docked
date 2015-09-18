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

  'views/user/form'
  ], ($, _, App, Mn, Template, translate, Select, Remove, Edit, SetAttrs, UserFormView)->
  UserView = Mn.ItemView.extend
    className: 'user pure-menu-item'

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

  UserView
