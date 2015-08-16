define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'collections/users'
  'views/user/view'
  'views/list'
  'text!templates/user/list_view.html'
  'views/user/form'], ($, _, Backbone, App, UsersCollection, UserView, ListView, UsersListTemplate, UserForm)->
  UsersListView = ListView.extend
    initialize: ->
      @listTemplate = UsersListTemplate
      @view = UserView

      ListView.prototype.initialize.apply(this, arguments)

      @$list = @$el.find('.pure-menu-list')

      @renderData()

      @addView = UserForm

      @

  UsersListView
