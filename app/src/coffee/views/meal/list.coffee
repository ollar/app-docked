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
  ], ($, _, Mn, App, MealsCollection, MealView, MealFormView, EmptyView, MealsListTemplate, translate, Sort, SelectAll, AddNew)->
  MealsListView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper meals-list'
    collection: new MealsCollection()
    template: _.template(MealsListTemplate)
    templateHelpers: ->
      t: translate
    childView: MealView

    childViewContainer: '.pure-menu-list'

    ui:
      sort: '#sort'
      addNew: '.add-new'

    initialize: ->
      @collection.fetch()

    behaviors:
      Sort:
        behaviorClass: Sort
      SelectAll:
        behaviorClass: SelectAll
      AddNew:
        behaviorClass: AddNew
        view: MealView
        formView: MealFormView

    emptyView: EmptyView

    MealsListView
