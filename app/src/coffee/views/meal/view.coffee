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
  'views/meal/comment'
  'views/meal/qty'

  'models/meal'
  ], ($, _, App, Mn, Template, marked, Select, Remove, Edit, Draggable, QtyElTemplate, RemoveButtonTemplate, MealFormView, CommentView, QtyView, MealModel)->
  MealView = Mn.LayoutView.extend
    className: 'meal pure-menu-item'

    model: new MealModel()

    regions: ->
      comments: '.comments'
      qty: '.qty-wrapper'

    initialize: (options)->
      @options = options || {}
      @success = no
      @failed = no
      @routeName = Backbone.history.getFragment()

      @listenTo App.vent, 'order:meal_'+@model.get('id')+':create:success', (model)->
        @orderSuccess(model.get('quantity'), model.get('id'))

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
      humanizeDay: @model.humanizeDay
      humanizeCategory: @model.humanizeCategory
      loggedUser: @loggedUser
      routeName: @routeName

    qtyEl: _.template(QtyElTemplate)
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

      meal_comment = _.find local_comments, (comment)=>
        comment.meal_id == @model.get('id')

      @comment = new CommentView(
        model: new Backbone.Model(meal_comment)
        meal_id: @model.get('id')
      )

    onRender: ->
      @$el.attr 'data-id', @model.get('id')
      @$el.toggleClass 'disabled', !@model.get('enabled')
      @$el.attr 'data-day', @model.get('day_linked')
      @$el.attr 'dats-category', @model.get('category')

      if @loggedUser.id != 0
        if @routeName == ''
          @qty.show(new QtyView())
        @comments.show(@comment)

  MealView
