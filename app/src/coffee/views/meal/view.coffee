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

  'views/meal/form'
  'views/meal/comment'
  'views/meal/qtyChanger'
  'views/meal/qtyNumber'

  'models/meal'
  'models/mealQty'
  ], ($, _, App, Mn, Template, marked, Select, Remove, Edit, MealFormView, CommentView, QtyCharger, QtyNum, MealModel, QtyModel)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    regions: ->
      qtyNum: '.name .qty-num'
      comments: '.comments'
      qtyChanger: '.qty-wrapper'

    initialize: (options)->
      @options = options || {}
      @qtyModel = new QtyModel()
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderedMeal = model.toJSON()
        @orderSuccess()
        @qtyModel.set('ordered', yes)
        @render()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:failed', ->
        @orderFailed()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':remove:success', ->
        @success = no
        @select = no
        @qtyModel = new QtyModel()
        @orderedMeal = {}
        @selectToggle().render()


      @listenTo App.vent, 'comment:meal_'+@model.get('id')+':create:success comment:meal_'+@model.get('id')+':remove:success', =>
        @render()

    template: _.template Template
    templateHelpers: ->
      marked: marked
      loggedUser: @loggedUser
      routeName: @routeName
      success: @success

    ui: ->
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

    # ==========================================================================

    selectToggle: ->
      @$el.toggleClass 'select', @select
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed
      @

    orderSuccess: ->
      @select = no
      @success = yes
      @selectToggle()

    orderFailed: ->
      @failed = yes
      @select = no
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

      App.execute 'order:create',
        id: $.cookie 'id'
        qty: @qtyModel.get('count')
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'

    removeOrder: ->
      App.execute 'order:remove', @orderedMeal.id, @model.id

    # ==========================================================================

    onBeforeRender: ->
      @orderedMeal = {}
      @loggedUser = App.ventFunctions.getLoggedUser (localUser)=>

        local_comments = localUser.get('comments')
        local_orders = localUser.get('orders')

        meal_comment = _.find local_comments, (comment)=>
          comment.meal_id == @model.get('id')

        @comment = new CommentView(
          model: new Backbone.Model(meal_comment)
          meal_id: @model.get('id')
        )

        if !@orderedMeal.id
          @orderedMeal = _.find local_orders, (order)=>
            order.meal_id == @model.get('id') and order.order_date == @model.get('order_date')

        if @orderedMeal
          @qtyModel.set({'count': @orderedMeal.quantity, ordered: yes})
          @orderSuccess()

      @

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.attr 'data-day', @model.get('day_linked')
      @$el.attr 'dats-category', @model.get('category')
      @$el.attr 'data-order-date', @model.get('order_date')

      if @loggedUser.id != 0 and @routeName == ''
        @qtyNum.show(new QtyNum({model: @qtyModel}))
        if !@success
          @qtyChanger.show(new QtyCharger({model: @qtyModel}))
        @comments.show(@comment)

      @

  MealView
