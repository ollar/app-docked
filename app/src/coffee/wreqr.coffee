define [
  'app'
  'marionette'
  'models/userDetails'
  'models/loggedUser'
  'models/order'
  'models/comment'
  'views/message'
  'views/loader'
  'translate'
  ], (App, Mn, UserDetailsModel, LoggedUserModel, OrderModel, CommentModel, MessageView, Loader,  translate)->

  App.ventFunctions =
    getLoggedUser: (callback)->
      loggedUser = new LoggedUserModel {id: $.cookie 'id'}
      loggedUser.fetch
        success: (model, response, options)->
          if typeof callback == 'function'
            callback.call(@, model)
      loggedUser

    updateLocalUser: (callback)->
      loggedUser = @getLoggedUser()
      userModel = new UserDetailsModel({id: $.cookie 'id'})
      userModel.fetch
        success: (model, request, options)=>
          model.unset 'password'
          model.unset 'timestamp_created'
          model.unset 'timestamp_modified'
          loggedUser.save model.toJSON(),
            success: (model, response, options)->
              if typeof callback == 'function'
                callback.call(@, arguments)
              App.vent.trigger 'localUser:update:success'

    destroyLocalUser: (callback)->
      loggedUser = @getLoggedUser()
      loggedUser.destroy
        success: ->
          if typeof callback == 'function'
            callback.call(@)
          App.vent.trigger 'localUser:destroy:success'


    lazyMessage: _.debounce (_data)->
      message = new MessageView({data: _data})
    , 300

  # ============================================================================
  # =================================================================== ##Orders
  # ============================================================================

  App.commands.setHandler 'order:create', (data, mealView)->
    orderModel = new OrderModel()
    orderModel.save
      user_id: data.id
      quantity: data.qty
      meal_id: data.meal_id
      order_date: data.order_date
    ,
      success: (model, response, options)=>
        App.ventFunctions.updateLocalUser ->
          App.execute 'message', {type: 'success', text: translate "meal added to your menu"}
          if mealView
            mealView.trigger "order:create:success", model

      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
        if mealView
          mealView.trigger "order:create:failed"

  App.commands.setHandler 'order:remove', (order_id, meal_id, mealView)->
    orderModel = new OrderModel({id: order_id})
    orderModel.destroy
      success: =>
        App.ventFunctions.updateLocalUser ->
          App.execute 'message', {type: 'success', text: translate "meal removed from your menu"}
          if mealView
            mealView.trigger 'order:remove:success'
      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}
        if mealView
          mealView.trigger "order:remove:failed"


  # ============================================================================
  # ================================================================= ##Comments
  # ============================================================================

  App.commands.setHandler 'comment:create', (data, mealView)->
    if data.content.length == 0
      App.vent.trigger 'comment:meal_'+data.meal_id+':create:success'
      return
    comment = new CommentModel()
    comment.save data,
      success: (model, response, options)=>
        App.ventFunctions.updateLocalUser ->
          if mealView
            mealView.trigger 'comment:create:success'
      error: (model, response, options)=>
        App.execute 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

  App.commands.setHandler 'comment:remove', (id, meal_id, mealView)->
    comment = new CommentModel({id: id})
    comment.destroy
      success: =>
        App.ventFunctions.updateLocalUser ->
          if mealView
            mealView.trigger 'comment:remove:success'
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
    @loader = new Loader()
    @trigger 'menu:hide'

  App.vent.on 'loading:done', ->
    @loader.$el.fadeOut()
    _.delay (=>@loader.remove()), 500

  # ============================================================================
  # ============================================================================
