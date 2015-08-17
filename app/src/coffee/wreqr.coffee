define [
  'app'
  'underscore'
  'marionette'
  'models/loggedUser'
  'models/order'
  'models/comment'
  'views/message'
  'views/loader'
  'mandrill_client'], (App, _, Mn, LoggedUserModel, OrderModel, CommentModel, MessageView, Loader, mandrill_client)->

  App.ventFunctions =
    getLoggedUser: ->
      loggedUser = new LoggedUserModel {id: $.cookie 'id'}
      loggedUser.fetch()
      loggedUser

    updateLocalUser: (newModel, mode='order_add')->
      loggedUser = @getLoggedUser()
      if mode == 'order_add'
        loggedUser.get('orders').push newModel
      else if mode == 'order_remove'
        localUserOrders = loggedUser.get('orders')
        loggedUser.set {'orders': _.reject(localUserOrders, (order)->order.id == parseInt(newModel.get('id')))}
      else if mode == 'comment_add'
        loggedUser.get('comments').push newModel
      else if mode == 'comment_remove'
        localUserComments = loggedUser.get('comments')
        loggedUser.set {'comments': _.reject(localUserComments, (comment)->comment.id == parseInt(newModel.get('id')))}

      loggedUser.save()

    lazyMessage: _.debounce (_data)->
      message = new MessageView({data: _data})
    , 300

  # ============================================================================

  App.vent.on 'localUser:create', (data)->
    user = new LoggedUserModel(data)

    user.unset 'token'
    user.unset 'timestamp_created'
    user.unset 'timestamp_modified'
    user.save {},
      success: =>
        @trigger 'localUser:create:success'

  App.vent.on 'localUser:update', (userModel) ->
    loggedUser = App.ventFunctions.getLoggedUser()
    userModel.unset 'password'
    userModel.unset 'timestamp_created'
    userModel.unset 'timestamp_modified'
    loggedUser.save userModel.toJSON(),
      success: =>
        @trigger 'localUser:update:success'

  App.vent.on 'localUser:destroy', (uid)->
    user = new LoggedUserModel({id: uid})
    user.destroy
      success: =>
        @trigger 'localUser:destroy:success'

  # ============================================================================

  App.vent.on 'order:create', (data)->
    orderModel = new OrderModel()
    orderModel.save
      user_id: data.id
      quantity: data.qty
      meal_id: data.meal_id
      order_date: data.order_date
    ,
      success: (model, response, options)=>
        model.unset 'timestamp_created'
        model.unset 'timestamp_modified'
        App.ventFunctions.updateLocalUser model
        @trigger 'message', {type: 'success', text: "Meal added to your menu"}
        @trigger "order:meal_"+data.meal_id+":create:success", model

      error: (model, response, options)=>
        @trigger "order:meal_"+data.meal_id+":create:failed"
        @trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.vent.on 'order:remove', (order_id, user_id=$.cookie('id'), meal_id=null)->
    orderModel = new OrderModel({id: order_id})
    loggedUser = @getLoggedUser()
    if !meal_id?
      meal_id = _.where(loggedUser.get('orders'), {id: parseInt(order_id)}).pop().meal_id
    orderModel.destroy
      success: =>
        if parseInt(user_id) == parseInt($.cookie('id'))
          @trigger 'message', {type: 'success', text: "Meal removed from your menu"}
        else
          @trigger 'message', {type: 'success', text: "Order removed"}

        @trigger 'order:meal_'+meal_id+':remove:success'
        App.ventFunctions.updateLocalUser(orderModel, 'order_remove')

  App.vent.on 'comment:create', (data)->
    if data.content.length == 0
      @trigger 'comment:meal_'+data.meal_id+':create:success'
      return
    comment = new CommentModel()
    comment.save data,
      success: (model, response, options)=>
        @updateLocalUser(comment, 'comment_add')
        @trigger 'comment:meal_'+data.meal_id+':create:success'
      error: (model, response, options)=>
        @trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.vent.on 'comment:remove', (id, meal_id)->
    comment = new CommentModel({id: id})
    comment.destroy
      success: =>
        App.ventFunctions.updateLocalUser(comment, 'comment_remove')
        @trigger 'comment:meal_'+meal_id+':remove:success'
      error: (model, response, options)=>
        @trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.vent.on 'email:send', (data, success, fail)->
    mandrill_client(data.html, data.toemail, data.toname, data.subject, data.text, success, fail)

  # ============================================================================

  App.vent.on 'message', (data)->
    console.log _.now(), data.text
    App.ventFunctions.lazyMessage.call(@, data)

  # ============================================================================

  App.vent.on 'loading:start', ->
    console.log 'start', _.now()
    @loader = new Loader()

  App.vent.on 'loading:done', ->
    console.log 'done', _.now()
    @loader.$el.fadeOut()
    _.delay((=>@loader.remove()), 500)

  # ============================================================================

  App.vent.on 'loading:done', ->
    @trigger 'menu:hide'

  # ============================================================================
  # ============================================================================
