define [
  'app'

  'views/home'

  'views/meal/list'

  'views/user/list'
  'views/user/login'
  'views/user/form'

  'views/order/list'

  'views/comment/list'
  ], (App, HomeView, MealsList, UsersList, LoginView, UserFormView, OrdersListView, CommentsListView)->

  Controller =
    setTitle: (_title)->
      document.title = _title

    home: ->
      @setTitle('Home')
      App.main.show(new HomeView())

    showMeals: ->
      @setTitle('Meals list')
      App.main.show(new MealsList())

    showUsers: ->
      @setTitle('Users list')
      App.main.show(new UsersList())

    login: ->
      @setTitle('Login')
      if $.cookie 'id'
        @logout(yes)
      App.main.show(new LoginView())

    logout: (quite=false)->
      uid = $.cookie 'id'
      $.removeCookie 'id'
      $.removeCookie 'access_token'

      if !quite
        App.vent.trigger 'localUser:destroy', uid
        App.vent.trigger 'message', {text: 'Good bye!'}

        App.navigate '', yes

    register: ->
      @setTitle('Register')
      App.main.show(new UserFormView())

    userEdit: (id)->
      @setTitle('User Settings')
      user = new UserModel({id: id})
      user.fetch
        success: (model, response, options)=>
          App.view = new UserFormView({model: model})
          @content.html App.view.render().el
        error: (collection, response, options)=>
          App.vent.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

      App.main.show new UserFormView({model: model})

    ordersList: ->
      @setTitle('Orders List')
      App.main.show(new OrdersListView())

    viewComments: ->
      @setTitle('Comments List')
      App.main.show(new CommentsListView())





  Controller
