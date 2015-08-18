define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/meal/view.html'
  'marked'
  'behaviors/select'
  'translate'

  'text!templates/meal/qty_el.html'
  'text!templates/meal/remove_button.html'
  'views/meal/form'
  'views/comment/form'
  'models/comment'
  ], ($, _, App, Mn, Template, marked, Select, translate, QtyElTemplate, RemoveButtonTemplate, MealFormView, CommentFormView, CommentModel)->
  MealView = Mn.ItemView.extend
    className: 'meal pure-menu-item'

    initialize: (options)->
      @options = options || {}
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()
      @loggedUser = App.ventFunctions.getLoggedUser()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderSuccess(model.get('quantity'), model.get('id'))

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:failed', ->
        @orderFailed()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':remove:success', ->
        @success = no
        @selected = no
        @selectToggle().render()

      @listenTo App.vent, 'comment:meal_'+@model.get('id')+':create:success comment:meal_'+@model.get('id')+':remove:success', =>
        @model.fetch
          success: (model, response, options)=>
            @render()

    template: _.template Template
    templateHelpers: ->
      marked: marked
      humanizeDay: @model.humanizeDay
      humanizeCategory: @model.humanizeCategory
      loggedUser: @loggedUser
      routeName: @routeName
      t: translate

    qtyEl: _.template(QtyElTemplate)
    removeOrderButton: _.template(RemoveButtonTemplate)

    events:
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

    behaviors:
      Select:
        behaviorClass: Select

    # ==========================================================================

    selectToggle: ->
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed
      @

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

    # ================================

    editMeal: ->
      mealFormView = new MealFormView
        model: @model
        front_view: MealView

      @$el.before mealFormView.render().el
      console.log mealFormView.render()
      @remove()

    toggleEnabled: ->
      @model.save {'enabled': !@model.get('enabled')},
        success: =>
          @selected = yes
          @selectToggle().render()

    removeMeal: ->
      App.vent.trigger 'message', {text: 'Meal removed'}
      @model.destroy()

    # ================================

    decreaseQty: ->
      @qtyInput = @$el.find('.qty input')
      if @qtyInput.val() > 1 then @qtyInput.attr 'value', parseInt(@qtyInput.val()) - 1 else return

    increaseQty: ->
      @qtyInput = @$el.find('.qty input')
      @qtyInput.attr 'value', parseInt(@qtyInput.val()) + 1

    # ================================

    makeOrder: ->
      if @success
        @orderFailed()
        _.delay(()=>
          @failed = no
          @orderSuccess()
        , 1000)
        return

      _qty = @$el.find('.qty input').val()
      App.vent.trigger 'order:create',
        id: $.cookie 'id'
        qty: _qty
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'

    removeOrder: (e)->
      e.preventDefault()
      e.stopPropagation()

      order_id = $(e.target).attr('data-order-id')
      App.vent.trigger 'order:remove', order_id

    # ================================

    addComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      $comments = @$el.find('.comments')

      formView = new CommentFormView
        model: new CommentModel()
        meal_id: @model.get('id')
        user_id: App.ventFunctions.getLoggedUser().id
      $comments.html formView.render().el

    removeComment: (e)->
      e.preventDefault()
      e.stopPropagation()

      commentId = $(e.target).attr 'data-comment-id'
      App.vent.trigger 'comment:remove', commentId, @model.get('id')

    # ==========================================================================

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.addClass 'day-' + @model.get('day_linked')
      @$el.addClass 'category-' + @model.get('category')


  MealView
