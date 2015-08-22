define [
  'app'

  'views/home'

  'views/meal/list'

  'views/user/list'
  'views/user/login'
  'views/user/form'

  'views/order/list'

  'views/comment/list'

  'views/stats/week'
  'views/stats/weekCommon'
  'views/stats/month'
  'views/stats/monthCommon'

  'translate'
  ], (App, HomeView, MealsList, UsersList, LoginView, UserFormView, OrdersListView, CommentsListView, UserStatsView, UserStatsWeekCommon, MonthStatsView, MonthStatsViewCommon, t)->

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

    weekMenu: (user_id)->
      if user_id
        @setTitle(user_id + 'Week Menu')
      else
        @setTitle('Your Week Menu')

      App.main.show(new UserStatsView({user_id: user_id}))

    weekMenuAll: ->
      @setTitle('Common Week Menu')
      App.main.show(new UserStatsWeekCommon())

    monthStats: (user_id, month)->
      @setTitle('Month Stats')

      App.main.show(new MonthStatsView({month: parseInt(month), user_id: user_id}))

    monthStatsAll: (month)->
      @setTitle('Common Month Stats')

      App.main.show(new MonthStatsViewCommon({month: month}))


  Controller
