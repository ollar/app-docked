define [
  'jquery'
  'underscore'
  'marionette'
  'app'
  'collections/meals'
  'views/meal/view'
  'views/meal/form'
  'views/common/empty'
  'text!templates/meal/list_view.html'
  'translate'
  'behaviors/sort'
  'behaviors/select_all'
  'behaviors/add_new'
  'behaviors/paginate'
  ], ($, _, Mn, App, MealsCollection, MealView, MealFormView, EmptyView, MealsListTemplate, translate, Sort, SelectAll, AddNew, Paginate)->
  MealsListView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper meals-list'
    collection: new MealsCollection()
    template: _.template(MealsListTemplate)
    templateHelpers: ->
      t: translate
    childView: MealView

    childViewContainer: '.pure-menu-list'

    initialize: ->
      @collection.fetch()

    behaviors:
      Sort:
        behaviorClass: Sort
      SelectAll:
        behaviorClass: SelectAll
      AddNew:
        behaviorClass: AddNew
        itemView: MealView
        formView: MealFormView
      Paginate:
        behaviorClass: Paginate

    emptyView: EmptyView

    MealsListView
