define [
  'jquery'
  'underscore'
  'backbone'
  'marionette'

  'views/meal/view'

], ($, _, Backbone, Mn, MealView) ->

  DayView = Mn.CollectionView.extend

    className: "test"

    childView: MealView

    initialize: (options)->
      @options = options || {}
      @collection = options.collection || new Backbone.Collection()

      # console.log @


  DayView
