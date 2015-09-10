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
  'behaviors/paginate'
  'behaviors/infinite_load'
  ], ($, _, App, Mn, UsersCollection, UserView, UserFormView, EmptyView, UsersListTemplate, translate, Sort, AddNew, Paginate,
  Inf)->
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
      Sort:
        behaviorClass: Sort
      AddNew:
        behaviorClass: AddNew
        itemView: UserView
        formView: UserFormView
      Inf:
        behaviorClass: Inf

    emptyView: EmptyView

  UsersListView
