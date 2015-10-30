define [
  'app'
  'marionette'
  'collections/users'
  'views/user/view'
  'views/user/form'
  'views/common/empty'
  'text!templates/user/list_view.html'
  'translate'
  'behaviors/add_new'
  'behaviors/infinite_load'
  ], (App, Mn, UsersCollection, UserView, UserFormView, EmptyView, UsersListTemplate, translate, AddNew,
  Infinite)->
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

    behaviors:
      AddNew:
        behaviorClass: AddNew
        itemView: UserView
        formView: UserFormView
      Infinite:
        behaviorClass: Infinite

    emptyView: EmptyView

  UsersListView
