define [
  'app'
  'underscore'
  'marionette'
  'models/user'
  'models/loggedUser'
  'models/order'
  'models/comment'
  'views/message'
  'views/loader'
  'mandrill_client'
  'translate'
  ], (App, _, Mn, UserModel, LoggedUserModel, OrderModel, CommentModel, MessageView, Loader, mandrill_client, translate)->

  App.ventFunctions =
    getLoggedUser: ->
      loggedUser = new LoggedUserModel {id: $.cookie 'id'}
      loggedUser.fetch()
      loggedUser

    updateLocalUser: ()->
      loggedUser = @getLoggedUser()
      userModel = new UserModel({id: $.cookie 'id'})
      userModel.fetch
        success: (model, request, options)=>
          model.unset 'password'
          model.unset 'timestamp_created'
          model.unset 'timestamp_modified'
          loggedUser.save model.toJSON(),
            success: ->
              App.vent.trigger 'localUser:update:success'

    destroyLocalUser: ->
      loggedUser = @getLoggedUser()
      loggedUser.destroy
        success: ->
          App.vent.trigger 'localUser:destroy:success'


    lazyMessage: _.debounce (_data)->
      message = new MessageView({data: _data})
    , 300

  # ============================================================================
  # =================================================================== ##Orders
  # ============================================================================

  App.commands.setHandler 'order:create', (data)->
    orderModel = new OrderModel()
    orderModel.save
      user_id: data.id
      quantity: data.qty
      meal_id: data.meal_id
      order_date: data.order_date
    ,
      success: (model, response, options)=>
        App.ventFunctions.updateLocalUser()
        App.execute 'message', {type: 'success', text: translate "meal added to your menu"}
        App.vent.trigger "order:meal_"+data.meal_id+":create:success", model

      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
        App.vent.trigger "order:meal_"+data.meal_id+":create:failed"

  App.commands.setHandler 'order:remove', (order_id, meal_id)->
    orderModel = new OrderModel({id: order_id})
    orderModel.destroy
      success: =>
        App.execute 'message', {type: 'success', text: translate "meal removed from your menu"}
        App.vent.trigger 'order:meal_'+meal_id+':remove:success'
        App.ventFunctions.updateLocalUser()
      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
        App.vent.trigger "order:meal_"+meal_id+":remove:failed"


  # ============================================================================
  # ================================================================= ##Comments
  # ============================================================================

  App.commands.setHandler 'comment:create', (data)->
    if data.content.length == 0
      App.vent.trigger 'comment:meal_'+data.meal_id+':create:success'
      return
    comment = new CommentModel()
    comment.save data,
      success: (model, response, options)=>
        App.ventFunctions.updateLocalUser()
        App.vent.on 'localUser:update:success', ->
          App.vent.trigger 'comment:meal_'+data.meal_id+':create:success'
      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.commands.setHandler 'comment:remove', (id, meal_id)->
    comment = new CommentModel({id: id})
    comment.destroy
      success: =>
        App.ventFunctions.updateLocalUser()
        App.vent.on 'localUser:update:success', ->
          App.vent.trigger 'comment:meal_'+meal_id+':remove:success'
      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.commands.setHandler 'email:send', (data, success, fail)->
    mandrill_client(data.html, data.toemail, data.toname, data.subject, data.text, success, fail)

  # ============================================================================

  App.commands.setHandler 'message', (data)->
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
    @trigger 'menu:hide'

  # ============================================================================
  # ============================================================================
