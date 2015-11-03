define [
  'app'
  'marionette'
  'text!templates/meal/viewHome.html'
  'text!templates/meal/qty_el.html'
  'marked'
  'behaviors/select'
  'behaviors/setAttrs'
  'behaviors/loading'

  'views/meal/form'
  'views/meal/comment'
  'views/meal/qtyChanger'

  'models/meal'

  'collections/comments'
  ], (App, Mn, Template, QtyTemplate, marked, Select, SetAttrs, Loading, MealFormView, CommentView, QtyCharger, MealModel,  CommentsCollection)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    template: _.template Template
    templateHelpers:
      marked: marked

    ui:
      title: '.name'
      makeOrder: '.make-order'
      removeOrder: '.remove-order'

    events:
      'click @ui.makeOrder': 'makeOrder'
      'click @ui.removeOrder': 'removeOrder'
      'click .show-comments': 'showComments'
      'click .hide-comments': 'hideComments'

    behaviors:
      Select:
        behaviorClass: Select
      SetAttrs:
        behaviorClass: SetAttrs
        attrs:
          'day': 'day_linked'
          'category': 'category'
          'order-date': 'order_date'
      Loading:
        behaviorClass: Loading

    regions:
      qtyChanger: '.qty-wrapper'
      comments: '.comments'
      buttons: '.buttons-wrapper'

    initialize: ->
      @success = no
      @failed = no
      @model.set
        qty: 1
        isOrdered: no

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderedMeal = model.toJSON()
        @model.set('isOrdered', yes)

        @orderSuccess()
        @trigger 'busy:stop'
        @render()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:failed', ->
        @trigger 'busy:stop'
        @orderFailed()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':remove:success', ->
        @success = no
        @select = no
        @orderedMeal = {}
        @model.set
          isOrdered: no
          qty: 1
        @trigger 'busy:stop'
        @selectToggle()
        @render()


      @listenTo App.vent, 'comment:meal_'+@model.get('id')+':create:success comment:meal_'+@model.get('id')+':remove:success', =>
        @trigger 'busy:stop'
        @comments.currentView.render()
        @render()


    # ==========================================================================

    setQty: ->
      _qty = @model.get('qty')
      return if _qty <= 0 or !@model.get('isOrdered')
      @ui.title.prepend(_.template(QtyTemplate)({qty: _qty}))


    selectToggle: ->
      @$el.toggleClass 'select', @select
      @$el.toggleClass 'success', @success
      @$el.toggleClass 'failed', @failed

      @qtyCharger.$el.toggle(!@model.get('isOrdered'));

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

    makeOrder: ->
      @trigger 'busy:start'

      if @success
        @orderFailed()
        _.delay(()=>
          @failed = no
          @orderSuccess()
        , 1000)
        return

      App.execute 'order:create',
        id: $.cookie 'id'
        qty: @model.get('qty')
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'

    removeOrder: ->
      @trigger 'busy:start'
      App.execute 'order:remove', @orderedMeal.id, @model.id

    # ==========================================================================
    #
    # onBeforeRender: ->
    #   if !@orderedMeal?
    #     @orderedMeal = {}
    #   @loggedUser = App.ventFunctions.getLoggedUser (localUser)=>
    #
    #     local_comments = localUser.get('comments')
    #     local_orders = localUser.get('orders')
    #
    #     meal_comment = _.find local_comments, (comment)=>
    #       comment.meal_id == @model.get('id')
    #
    #     @commentView = new CommentView(
    #       model: new Backbone.Model(meal_comment)
    #       meal_id: @model.id
    #     )
    #
    #     if !@orderedMeal.id
    #       @orderedMeal = _.find local_orders, (order)=>
    #         order.meal_id == @model.get('id') and order.order_date == @model.get('order_date')
    #
    #     if @orderedMeal
    #       @model.set({'qty': @orderedMeal.quantity, isOrdered: yes})
    #       @orderSuccess()
    #
    #   @

    onRender: ->
      @comments.show(@commentView)
      @qtyChanger.show(new QtyCharger({model: @model}))
      @setQty()


  MealView
