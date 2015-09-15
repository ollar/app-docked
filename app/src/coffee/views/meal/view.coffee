define [
  'jquery'
  'underscore'
  'app'
  'marionette'
  'text!templates/meal/view.html'
  'marked'
  'behaviors/select'
  'behaviors/remove'
  'behaviors/edit'
  'behaviors/draggable'

  'text!templates/meal/remove_button.html'
  'views/meal/form'
  'views/meal/comment'
  'views/meal/qtyChanger'
  'views/meal/qtyNumber'

  'models/meal'
  ], ($, _, App, Mn, Template, marked, Select, Remove, Edit, Draggable, RemoveButtonTemplate, MealFormView, CommentView, QtyView, QtyNum, MealModel)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    regions: ->
      qtyNum: '.name .qty-num'
      comments: '.comments'
      qty: '.qty-wrapper'

    initialize: (options)->
      @options = options || {}
      @orderedMeal = {}
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderSuccess()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:failed', ->
        @orderFailed()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':remove:success', ->
        @success = no
        @selected = no
        @selectToggle().render()

      @listenTo App.vent, 'comment:meal_'+@model.get('id')+':create:success comment:meal_'+@model.get('id')+':remove:success', =>
        @render()

    template: _.template Template
    templateHelpers: ->
      marked: marked
      loggedUser: @loggedUser
      routeName: @routeName
      success: @success

    removeOrderButton: _.template(RemoveButtonTemplate)

    ui: ->
      edit: '.edit'
      remove: '.remove'
      toggleEnabled: '.toggle-enabled'
      makeOrder: '.make-order'
      removeOrder: '.remove-order'
      panEl: '.name'

    events:
      'click @ui.toggleEnabled': 'toggleEnabled'
      'click @ui.makeOrder': 'makeOrder'
      'click @ui.removeOrder': 'removeOrder'

    behaviors:
      Select:
        behaviorClass: Select
      Remove:
        behaviorClass: Remove
        message: _('meal removed')
      Edit:
        behaviorClass: Edit
        formView: MealFormView
      Draggable:
        behaviorClass: Draggable
        direction: 'H'
        disable: ()->
          Math.abs(@move.get('X')) >= 50


    # ==========================================================================

    selectToggle: ->
      @$el.toggleClass 'selected', @selected
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed
      @

    orderSuccess: (qty=null, order_id=null)->
      @selected = no
      @success = yes

      @qtyNum.show(new QtyNum({model: @qty.currentView.model}))

      @selectToggle()

    orderFailed: ->
      @failed = yes
      @selected = no
      @selectToggle()
      _.delay =>
        @failed = no
        @selectToggle()
      , 1000

    # ================================

    toggleEnabled: ->
      @model.save {'enabled': !@model.get('enabled')},
        success: =>
          @select = yes
          @selectToggle().render()

    # ================================

    makeOrder: ->
      if @success
        @orderFailed()
        _.delay(()=>
          @failed = no
          @orderSuccess()
        , 1000)
        return

      _qty = @$('.qty input').val()

      App.execute 'order:create',
        id: $.cookie 'id'
        qty: _qty
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'

    removeOrder: (e)->
      e.preventDefault()
      e.stopPropagation()

      order_id = $(e.target).attr('data-order-id')
      App.execute 'order:remove', order_id, @model.id

    # ==========================================================================

    onBeforeRender: ->
      @loggedUser = App.ventFunctions.getLoggedUser()
      local_comments = @loggedUser.get('comments')
      local_orders = @loggedUser.get('orders')

      meal_comment = _.find local_comments, (comment)=>
        comment.meal_id == @model.get('id')

      @comment = new CommentView(
        model: new Backbone.Model(meal_comment)
        meal_id: @model.get('id')
      )

      @$el.attr 'data-order-date', @model.get('order_date')
      @orderedMeal = _.find local_orders, (order)=>
        order.meal_id == @model.get('id') and order.order_date == @model.get('order_date')

      console.log @success

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.attr 'data-day', @model.get('day_linked')
      @$el.attr 'dats-category', @model.get('category')


      if @loggedUser.id != 0
        if @routeName == '' and !@success
          @qty.show(new QtyView())
          if @orderedMeal
            @qty.currentView.model.set('count', @orderedMeal.quantity)
            @orderSuccess()

        @comments.show(@comment)

  MealView
