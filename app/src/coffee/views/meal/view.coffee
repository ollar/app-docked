define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'marionette'
  'text!templates/meal/view.html'
  'marked'
  ], ($, _, Backbone, App, Mn, Template, marked)->
  MealView = Mn.ItemView.extend
    className: 'meal pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @selected = no
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()
      @loggedUser = {has: ->''}  # todo remove me

      @on 'stateToggle', ->
        @selected = !@selected
        @selectToggle()

    template: _.template Template
    templateHelpers: ->
      marked: marked
      humanizeDay: @model.humanizeDay
      humanizeCategory: @model.humanizeCategory
      loggedUser: @loggedUser
      routeName: @routeName

    events:
      'click': -> @trigger 'stateToggle'
      'click .edit': 'editMeal'
      'click .toggle-enabled': 'toggleEnabled'
      'click .remove': 'removeMeal'
      'click .make-order': 'makeOrder'
      'click .qty-wrapper': (e)-> e.stopPropagation()
      'click .decrease': 'decreaseQty'
      'click .increase': 'increaseQty'
      'click .remove-order': 'removeOrder'
      'click .add-comment': 'addComment'
      'click .remove-comment': 'removeComment'
      'click .comments': (e)-> e.stopPropagation()

    selectToggle: ->
      @$el.toggleClass 'selected', @selected
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed
      @

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.addClass 'day-' + @model.get('day_linked')
      @$el.addClass 'category-' + @model.get('category')


  MealView
