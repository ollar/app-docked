define [
  'marionette'
  'app'
  'collections/meals'
  'views/meal/view'
  'views/meal/form'
  'views/common/empty'
  'text!templates/meal/list_view.html'
  'translate'
  'behaviors/select_all'
  'behaviors/add_new'
  'behaviors/infinite_load'
  ], (Mn, App, MealsCollection, MealView, MealFormView, EmptyView, MealsListTemplate, translate, SelectAll, AddNew, Infinite)->
  MealsListView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper meals-list'
    collection: new MealsCollection()
    template: _.template(MealsListTemplate)
    templateHelpers: ->
      t: translate
      local_user: @local_user

    childView: MealView

    childViewContainer: '.pure-menu-list'

    initialize: ->
      @collection.fetch()
      @local_user = App.ventFunctions.getLoggedUser()

    behaviors:
      SelectAll:
        behaviorClass: SelectAll
      AddNew:
        behaviorClass: AddNew
        itemView: MealView
        formView: MealFormView
      Infinite:
        behaviorClass: Infinite

    emptyView: EmptyView

    MealsListView
