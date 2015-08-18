define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/user/view.html'
  'translate'
  'behaviors/select'
  'behaviors/delete'
  'views/user/form'
  ], ($, _, App, Mn, Template, translate, Select, Delete, UserFormView)->
  UserView = Mn.ItemView.extend
    className: 'user pure-menu-item'

    initialize: (options)->
      @options = options || {}

    template: _.template Template
    templateHelpers: ->
      t: translate

    ui:
      removeButton: '.remove'

    behaviors:
      Select:
        behaviorClass: Select
      Delete:
        behaviorClass: Delete
        model: @view
        # text: 'user "<i>'+@model.get('real_name')+'</i>" removed'

    events:
      'click .edit': 'editUser'

    editUser: ->
      userFormView = new UserFormView
        model: @model
        front_view: UserView

      @$el.before userFormView.render().el
      @remove()

    onRender: ->
      @$el.attr('data-id', @model.get('id'))


  UserView
