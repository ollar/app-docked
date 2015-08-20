define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/meal/form.html'
  'collections/meals'
  'models/meal'
  'translate'], ($, _, App, Mn, MealFormTemplate, MealsCollection, MealModel, translate)->

  MealFormView = Mn.ItemView.extend
    className: 'meal-manage pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @collection = new MealsCollection()
      @model = @model || new MealModel()

    template: _.template MealFormTemplate
    templateHelpers: ->
      humanizeDay: @model.humanizeDay
      humanizeCategory: @model.humanizeCategory
      t: translate

    events:
      'submit': 'updateMeal'
      'click .cancel': 'cancelEdit'

    updateMeal: (e)->
      e.preventDefault()

      _daysObj = @model.get 'daysObj'
      _categoriesObj = @model.get 'categoriesObj'
      @model.unset 'daysObj'
      @model.unset 'categoriesObj'

      data = $(e.target).serializeObject()

      @model.save data,
        success: (model, response, options)=>
          model.set {daysObj: _daysObj, categoriesObj: _categoriesObj}
          @options.front_view.model = model
          @options.front_view.render().$el.show()
          @remove()

      if @model.has 'id'
        App.execute 'message', {text: 'Meal updated'}
      else
        @collection.add @model
        App.execute 'message', {text: 'Meal created'}




    cancelEdit: (e)->
      e.preventDefault()

      if @model.has 'id'
        @options.front_view.$el.show()
      else
        @options.front_view.$el.remove()
      @remove()

  MealFormView
