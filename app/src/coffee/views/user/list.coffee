define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'collections/users'
  'views/user/view'
  'views/common/empty'
  'text!templates/user/list_view.html'
  'translate'], ($, _, Backbone, App, Mn, UsersCollection, UserView, EmptyView, UsersListTemplate, translate)->
  UsersListView = Mn.CompositeView.extend
    className: 'pure-menu menu-wrapper'

    collection: new UsersCollection()
    initialize: ->
      @collection.fetch()

    template: _.template UsersListTemplate
    templateHelpers: ->
      t: translate

    childView: UserView
    childViewContainer: '.pure-menu-list'

    emptyView: EmptyView

  UsersListView
