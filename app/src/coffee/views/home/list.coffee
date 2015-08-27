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

    ui:
      footer: '.buttons-wrapper'

    events:
      'click .go': 'makeOrder'

    initialize: ->
      @collection.fetch()

    behaviors:
      SelectAll:
        behaviorClass: SelectAll

    makeOrder: ->
      selected = []

      @children.each (view)->
        view.children.each (subview)->
          selected.push _.where subview, {select: yes}

      console.log selected

      # _.each selected, (mealView)->
      #   _qty = mealView.$el.find('.qty input').val()
      #   mealModel = mealView.model
      #
      #   App.vent.trigger 'order:create',
      #     id: $.cookie 'id'
      #     qty: _qty
      #     meal_id: mealModel.get 'id'
      #     order_date: mealModel.get 'order_date'
      #   , @

  HomeView
