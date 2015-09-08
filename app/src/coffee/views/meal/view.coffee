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

  'text!templates/meal/qty_el.html'
  'text!templates/meal/remove_button.html'
  'views/meal/form'
  'views/comment/form'
  'models/comment'
  'models/meal'
  ], ($, _, App, Mn, Template, marked, Select, Remove, Edit, Draggable, QtyElTemplate, RemoveButtonTemplate, MealFormView, CommentFormView, CommentModel, MealModel)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    regions:
      comments: '.comments'

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

    qtyEl: _.template(QtyElTemplate)
    removeOrderButton: _.template(RemoveButtonTemplate)

    ui:
      edit: '.edit'
      remove: '.remove'
      toggleEnabled: '.toggle-enabled'
      makeOrder: '.make-order'
      qtyWrapper: '.qty-wrapper'
      qtyInput: '.qty input'
      decrease: '.decrease'
      increase: '.increase'
      removeOrder: '.remove-order'
      addComment: '.add-comment'
      removeComment: '.remove-comment'
      comments: '.comments'
      panEl: '.name'

    events:
      'click @ui.toggleEnabled': 'toggleEnabled'
      'click @ui.makeOrder': 'makeOrder'
      'click @ui.qtyWrapper': (e)-> e.stopPropagation()
      'click @ui.decrease': 'decreaseQty'
      'click @ui.increase': 'increaseQty'
      'click @ui.removeOrder': 'removeOrder'
      'click @ui.addComment': 'addComment'
      'click @ui.removeComment': 'removeComment'
      'click @ui.comments': (e)-> e.stopPropagation()

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
      @$el.find('.left').hide()

      @$el.find('.name').prepend(@qtyEl({qty: qty})) if qty
      @$el.find('.right').html(@removeOrderButton({order_id: order_id})) if order_id

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

    decreaseQty: ->
      @qtyInput = @ui.qtyInput
      if @qtyInput.val() > 1 then @qtyInput.attr 'value', parseInt(@qtyInput.val()) - 1 else return

    increaseQty: ->
      @qtyInput = @ui.qtyInput
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

      _qty = @ui.qtyInput.val()
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
      App.execute 'comment:remove', commentId, @model.get('id')

    # ==========================================================================

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.attr 'data-day', @model.get('day_linked')
      @$el.attr 'dats-category', @model.get('category')


  MealView
