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

  'models/meal'

  'collections/comments'
  ], (App, Mn, Template, QtyTemplate, marked, Select, SetAttrs, Loading, MealFormView, CommentView, MealModel,  CommentsCollection)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    template: _.template Template
    templateHelpers: ->
      marked: marked

    ui:
      title: '.name'
      makeOrder: '.make-order'
      removeOrder: '.remove-order'

      decrease: '.decrease'
      increase: '.increase'

    events:
      'click @ui.makeOrder': 'makeOrder'
      'click @ui.removeOrder': 'removeOrder'
      'click .show-comments': 'showComments'
      'click .hide-comments': 'hideComments'

      'click @ui.decrease': 'decreaseQty'
      'click @ui.increase': 'increaseQty'

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

    bindings:
      '.qty-wrapper':
        attributes: [
          observe: 'isOrdered'
          name: 'class'
          onGet: (value)->
            'hidden' if value or !@loggedUser.id
        ]

      '.qty-wrapper .qty':
        observe: 'qty'

      '.name .qty':
        observe: ['qty', 'isOrdered']
        onGet: 'setQty'

      ':el':
        attributes: [
          observe: 'state'
          name: 'class'
          onGet: (value)->
            value
        ]

      'button.pure-button':
        attributes: [
          observe: ['isLogged', 'isOrdered']
          name: 'class'
          onGet: (values)->
            if !values[0]
              return 'hidden'
            else
              if values[1] then 'remove-order' else 'make-order pure-button-primary'
          ]
        observe: 'isOrdered'
        onGet: (value)->
          if value then _.t('remove order') else _.t('make order')

      '.comments':
        attributes: [
          name: 'class'
          observe: 'isLogged'
          onGet: (value)->
            if !value then 'hidden' else ''
        ]


    initialize: ->
      @model.set
        state: ''
        qty: 1
        isOrdered: no
        orderId: 0
        isLogged: App.ventFunctions.getLoggedUser().id

      @commentView = new CommentView(
        model: new Backbone.Model()
        mealView: @
      )

      # ============================================================================================

      @on 'order:create:success', (model)->
        @model.set
          isOrdered: yes
          qty: model.get('quantity')
          orderId: model.get('id')
          state: 'success'

        @trigger 'busy:stop'

      @on 'order:create:failed', ->
        @trigger 'busy:stop'
        @orderFailed()

      @on 'order:remove:success order:remove:failed', ->
        @select = no
        @model.set
          isOrdered: no
          qty: 1
          orderId: 0
          state: ''
        @trigger 'busy:stop'


      @on 'comment:create:success comment:remove:success', =>
        @trigger 'busy:stop'
        @comments.currentView.render()


    # ==========================================================================

    decreaseQty: ()->
      return false if @model.get('qty') <= 1
      @model.set('qty', @model.get('qty')-1)
      no

    increaseQty: ()->
      @model.set('qty',  @model.get('qty')+1)
      no

    # ==========================================================================

    setQty: (values)->
      return if values[0] <= 0 or !values[1]
      values[0] + ' \u00D7 '


    orderFailed: ->
      _prevState = @model.get('state')

      @model.set('state', 'failed')
      _.delay(=>
        @model.set('state', _prevState)
      , 1000)

    # ================================

    makeOrder: ->
      @trigger 'busy:start'

      if @model.get('state') == 'success'
        @orderFailed()
        return

      App.execute 'order:create',
        id: $.cookie 'id'
        qty: @model.get('qty')
        meal_id: @model.get 'id'
        order_date: @model.get 'order_date'
      , @

    removeOrder: ->
      @trigger 'busy:start'
      App.execute 'order:remove', @model.get('orderId'), @model.id, @

    # ==========================================================================

    onBeforeRender: ->
      @loggedUser = App.ventFunctions.getLoggedUser (localUser)=>

        local_comments = localUser.get('comments')
        local_orders = localUser.get('orders')

        meal_comment = _.find local_comments, (comment)=>
          comment.meal_id == @model.get('id')

        @commentView = new CommentView(
          model: new Backbone.Model(meal_comment)
          mealView: @
        )

        orderedMeal = _.find local_orders, (order)=>
          order.meal_id == @model.get('id') and order.order_date == @model.get('order_date')

        if orderedMeal
          @model.set
            qty: orderedMeal.quantity
            isOrdered: yes
            orderId: orderedMeal.id
            state: 'success'

      @

    onBeforeShow: ->
      @comments.show(@commentView)


    onRender: ->
      @stickit()


  MealView
