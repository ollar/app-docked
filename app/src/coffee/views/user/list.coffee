define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'collections/users'
  'views/user/view'
  'views/user/form'
  'views/common/empty'
  'text!templates/user/list_view.html'
  'translate'
  'behaviors/sort'
  'behaviors/add_new'
  ], ($, _, App, Mn, UsersCollection, UserView, UserFormView, EmptyView, UsersListTemplate, translate, Sort, AddNew)->
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

    ui:
      sort: '#sort'
      addNew: '.add-new'

    behaviors:
      Sort:
        behaviorClass: Sort
      AddNew:
        behaviorClass: AddNew
        itemView: UserView
        formView: UserFormView

    emptyView: EmptyView

  UsersListView
