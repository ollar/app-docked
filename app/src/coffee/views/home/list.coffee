define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'views/meal/view'
  'views/home/day'
  'text!templates/home/view.html'
  'collections/nextWeekMeals'
  'behaviors/select_all'
  'translate'
  ], ($, _, App, Mn, MealView, DayView, HomeTemplate, NWMealsCollection, SelectAll, translate)->
  HomeView = Mn.CompositeView.extend

    className: 'pure-menu menu-wrapper'

    collection: new NWMealsCollection()
    childView: DayView
    childViewContainer: '.pure-menu-list'

    template: _.template HomeTemplate
    templateHelpers: ->
      t: translate
      local_user: @local_user

    ui:
      footer: '.buttons-wrapper'

    events:
      'click .go': 'makeOrder'

    initialize: ->
      App.ventFunctions.updateLocalUser()
      @collection.fetch()
      @local_user = App.ventFunctions.getLoggedUser()

    behaviors:
      SelectAll:
        behaviorClass: SelectAll

    makeOrder: ->
      selected = []

      @children.each (child)->
        child.children.each (_child)->
          selected.push _child if _child.select == true

      _.each selected, (view)->
        _qty = view.$('.qty input').val()
        mealModel = view.model

        App.execute 'order:create',
          id: $.cookie 'id'
          qty: _qty
          meal_id: mealModel.get 'id'
          order_date: mealModel.get 'order_date'
        , @

  HomeView
