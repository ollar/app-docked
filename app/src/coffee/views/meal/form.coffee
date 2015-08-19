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
      # @collection.add @model

      _daysObj = @model.get 'daysObj'
      _categoriesObj = @model.get 'categoriesObj'
      @model.unset 'daysObj'
      @model.unset 'categoriesObj'

      @model.save $(e.target).serializeObject(),
        success: (model, response, options)=>
          if @model.has 'id'
            App.execute 'message', {text: 'Meal updated'}
          else
            App.execute 'message', {text: 'Meal created'}
          model.set {daysObj: _daysObj, categoriesObj: _categoriesObj}
          @options.front_view.model = model
          @options.front_view.render().$el.show()
          @remove()

    cancelEdit: (e)->
      e.preventDefault()

      if @model.has 'id'
        @options.front_view.$el.show()
      @remove()

  MealFormView
