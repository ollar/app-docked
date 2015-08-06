define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'channel'
  'text!templates/meal/view.html'
  'text!templates/meal/qty_el.html'
  'text!templates/meal/remove_button.html'
  'views/meal/form'
  'views/comment/form'
  'models/comment'
  'marked'
  'translate'], ($, _, Backbone, App, channel, MealTemplate, QtyElTemplate, RemoveButtonTemplate, MealFormView, CommentFormView, CommentModel, marked, translate)->
  MealView = Backbone.View.extend
    className: 'meal pure-menu-item'

    initialize: (option)->
      @option = option || {}
      @selected = no
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()

      @on 'stateToggle', ->
        @selected = !@selected
        @selectToggle()

      @on 'select', ->
        @selected = yes
        @selectToggle()

      @listenTo channel, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderSuccess(model.get('quantity'), model.get('id'))

      @listenTo channel, 'order:meal_'+@model.get('id')+':create:failed', ->
        @orderFailed()

      @listenTo channel, 'order:meal_'+@model.get('id')+':remove:success', ->
        @success = no
        @selected = no
        @selectToggle().render()

      @listenTo channel, 'comment:meal_'+@model.get('id')+':create:success comment:meal_'+@model.get('id')+':remove:success', =>
        @model.fetch
          success: (model, response, options)=>
            @render()

      @listenTo @model, 'destroy', ->
        @remove()

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

    template: _.template(MealTemplate)

    editMeal: ->
      mealFormView = new MealFormView
        model: @model
        front_view: MealView

      @$el.before mealFormView.render().el
      @remove()

    qtyEl: _.template(QtyElTemplate)
    removeOrderButton: _.template(RemoveButtonTemplate)

    selectToggle: ->
      @$el.toggleClass 'selected', @selected
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed
      @

    toggleEnabled: ->
      @model.save {'enabled': !@model.get('enabled')},
        success: =>
          @selected = yes
          @selectToggle().render()

    removeMeal: ->
      channel.trigger 'message', {text: 'Meal removed'}
      @model.destroy()

    decreaseQty: ->
      @qtyInput = @$el.find('.qty input')
      if @qtyInput.val() > 1 then @qtyInput.attr 'value', parseInt(@qtyInput.val()) - 1 else return

    increaseQty: ->
      @qtyInput = @$el.find('.qty input')
      @qtyInput.attr 'value', parseInt(@qtyInput.val()) + 1

    orderSuccess: (qty=null, order_id=null)->
      @selected = no
      @success = yes
      @$el.find('.left').hide()

      @$el.find('.name').prepend(@qtyEl({qty: qty})) if qty
      @$el.find('.right').html(@removeOrderButton({order_id: order_id, t: translate})) if order_id

      @selectToggle()

    orderFailed: ->
      @failed = yes
      @selected = no
      @selectToggle()
      _.delay ()=>
        @failed = no
        @selectToggle()
      , 1000

    makeOrder: ->
      if @success
        @orderFailed()
        _.delay(()=>
          @failed = no
          @orderSuccess()
        , 1000)
        return

      _qty = @$el.find('.qty input').val()
      channel.trigger 'order:create',
        id: $.cookie 'id'
        qty: _qty
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'

    removeOrder: (e)->
      e.preventDefault()
      e.stopPropagation()

      order_id = $(e.target).attr('data-order-id')
      channel.trigger 'order:remove', order_id

    addComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      $comments = @$el.find('.comments')

      formView = new CommentFormView
        model: new CommentModel()
        meal_id: @model.get('id')
        user_id: channel.getLoggedUser().id
      $comments.html formView.render().el

    removeComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      commentId = $(e.target).attr 'data-comment-id'
      channel.trigger 'comment:remove', commentId, @model.get('id')

    render: ->
      loggedUser = channel.getLoggedUser()
      @$el.html @template _.extend @model.toJSON(),
        humanizeDay: @model.humanizeDay
        humanizeCategory: @model.humanizeCategory
        loggedUser: loggedUser
        routeName: @routeName
        marked: marked
        t: translate

      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.addClass 'day-' + @model.get('day_linked')
      @$el.addClass 'category-' + @model.get('category')

      @

  MealView
