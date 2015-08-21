define [
  'app'

  'views/home'

  'views/meal/list'

  'views/user/list'
  'views/user/login'
  'views/user/form'

  'views/order/list'

  'views/comment/list'
  'translate'
  ], (App, HomeView, MealsList, UsersList, LoginView, UserFormView, OrdersListView, CommentsListView, t)->

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
      App.vent.trigger 'localUser:destroy', uid

      if !quite
        App.execute 'message', {text: t 'good bye'}

        App.navigate ''

    register: ->
      @setTitle('Register')
      App.main.show(new UserFormView())

    userEdit: (id)->
      @setTitle('User Settings')
      App.main.show new UserFormView({user_id: id})

    ordersList: ->
      @setTitle('Orders List')
      App.main.show(new OrdersListView())

    viewComments: ->
      @setTitle('Comments List')
      App.main.show(new CommentsListView())





  Controller
