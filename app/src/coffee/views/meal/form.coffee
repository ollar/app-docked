define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'text!templates/meal/form.html'
  'collections/meals'
  'models/meal'
  'channel'
  'translate'], ($, _, Backbone, App, MealFormTemplate, MealsCollection, MealModel, channel, translate)->

  MealFormView = Backbone.View.extend
    className: 'meal-manage pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @collection = new MealsCollection()
      @model = @model || new MealModel()

    template: _.template(MealFormTemplate)

    events:
      'submit': 'updateMeal'
      'click .cancel': 'cancelEdit'

    updateMeal: (e)->
      e.preventDefault()
      @collection.add @model

      _daysObj = @model.get 'daysObj'
      _categoriesObj = @model.get 'categoriesObj'
      @model.unset 'daysObj'
      @model.unset 'categoriesObj'

      @model.save $(e.target).serializeObject(),
        success: (model, response, options)=>
          if @model.has 'id'
            channel.trigger 'message',  {text: 'Meal updated'}
          else
            channel.trigger 'message',  {text: 'Meal created'}
          model.set {daysObj: _daysObj, categoriesObj: _categoriesObj}
          mealView = new @options.front_view {model: model}
          @$el.before mealView.render().el
          @remove()

    cancelEdit: (e)->
      e.preventDefault()

      if @model.has 'id'
        prevView = new @options.front_view {model: @model}
        @$el.before(prevView.render().el)
      @remove()

    render: ->
      @$el.html @template _.extend @model.toJSON(),
        humanizeDay: @model.humanizeDay
        humanizeCategory: @model.humanizeCategory
        t: translate

      @

  MealFormView
