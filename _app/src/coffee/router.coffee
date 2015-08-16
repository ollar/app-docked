define [
  'jquery'
  'underscore'
  'backbone'
  'app'
  'channel'

  'models/user'
  'collections/users'

  'models/meal'
  'collections/meals'
  'collections/nextWeekMeals'
  'collections/orders'
  'collections/comments'

  'views/meal/form'
  'views/meal/list'
  'views/user/form'
  'views/user/list'
  'views/order/list'
  'views/user/login'
  'views/home'
  'views/stats/week'
  'views/stats/weekCommon'
  'views/stats/month'
  'views/stats/monthCommon'
  'views/comment/list'

  'models/loggedUser'
  'views/topMenu'
  'views/body'
  ], ($, _, Backbone, App, channel, UserModel, UsersCollection, MealModel, MealsCollection, NWMealsCollection, OrdersCollection, CommentsCollection, MealFormView, MealsListView, UserFormView, UsersListView, OrdersListView, LoginView, HomeView, UserStatsView, UserStatsViewCommon, MonthStatsView, MonthStatsViewCommon, CommentView, LoggedUserModel, TopMenu, BodyView)->

  AppRouter = Backbone.Router.extend
    routes:
      '': 'home'
      'register': 'register'
      'users': 'usersList'
      'user/:id': 'userEdit'
      'login': 'login'
      'logout': 'logout'

      'meals': 'showMeals'

      'orders': 'ordersList'
      'stats/week/all': 'weekMenuAll'
      'stats/week(/u:user_id)': 'weekMenu'

      'stats/month/all(/m:month)': 'monthStatsAll'
      'stats/month(/u:user_id)(/m:month)': 'monthStats'

      'comments': 'viewComments'

    setTitle: (_title)->
      document.title = _title

    execute: (callback, args, name)->
      App.view.remove() if App.view

      # channel.trigger 'loading:start'
      (callback.apply(@, args)) if (callback)
      # channel.trigger 'loading:done'

      channel.trigger 'menu:hide'

    initialize: (option)->
      @option = option || {}

      @content = $("#main-content")

      @user = new LoggedUserModel({id: $.cookie 'id'})
      @user.fetch()

      topMenu = new TopMenu()
      bodyView = new BodyView()

    home: ->
      @setTitle('Home')
      collection = new NWMealsCollection()
      collection.fetch
        success: (model, response, options) =>
          App.view = new HomeView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    showMeals: ->
      @setTitle('Meals List')
      collection = new MealsCollection()
      collection.fetch
        success: (model, response, options) =>
          App.view = new MealsListView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    login: ->
      @setTitle('Login')
      if $.cookie 'id'
        @logout()
      App.view = new LoginView()
      @content.html App.view.render().el

    logout: ->
      uid = $.cookie 'id'
      $.removeCookie 'id'
      $.removeCookie 'access_token'

      channel.trigger 'localUser:destroy', uid
      channel.trigger 'message', {text: 'Good bye!'}

      App.router.navigate '', yes

    register: ->
      @setTitle('Register')
      App.view = new UserFormView()

      @content.html App.view.render().el

    usersList: ->
      @setTitle('User List')
      collection = new UsersCollection()
      collection.fetch
        success: (model, response, options)=>
          App.view = new UsersListView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    userEdit: (id)->
      @setTitle('User Settings')
      user = new UserModel({id: id})
      user.fetch
        success: (model, response, options)=>
          App.view = new UserFormView({model: model})
          @content.html App.view.render().el
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    ordersList: ->
      @setTitle('Orders List')
      collection = new OrdersCollection()
      collection.fetch
        success: (collection, response, options)=>
          App.view = new OrdersListView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    weekMenu: (user_id)->
      collection = new OrdersCollection()
      if user_id
        @setTitle(user_id + 'Week Menu')
        collection.url = '/stats/week?user_id=' + user_id
      else
        @setTitle('Your Week Menu')
        collection.url = '/stats/week?user_id=' + $.cookie 'id'

      collection.fetch
        success: (collection, response, options)=>
          App.view = new UserStatsView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    weekMenuAll: ->
      @setTitle('Common Week Menu')
      collection = new OrdersCollection()
      collection.url = '/stats/week'
      collection.fetch
        success: (collection, response, options)=>
          App.view = new UserStatsViewCommon({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    monthStats: (user_id, month)->
      @setTitle('Month Stats')
      collection = new OrdersCollection()
      if user_id
        collection.url = '/stats/month?user_id=' + user_id
      else
        collection.url = '/stats/month?user_id=' + $.cookie 'id'

      if month
        collection.url += '&month_number=' + month

      collection.fetch
        success: (collection, response, options)=>
          App.view = new MonthStatsView({collection: collection, content: @content, month: parseInt(month), user_id: user_id})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    monthStatsAll: (month)->
      @setTitle('Common Month Stats')
      collection = new OrdersCollection()
      collection.url = '/stats/month'
      collection.fetch
        success: (collection, response, options)=>
          App.view = new MonthStatsViewCommon({collection: collection, content: @content, month: month})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}

    viewComments: ->
      console.log 'CommentsCollection'

      collection = new CommentsCollection()
      collection.fetch
        success: (collection, response, options)=>
          App.view = new CommentView({collection: collection, content: @content})
        error: (collection, response, options)=>
          channel.trigger 'message', {type: response.responseJSON.type, text: response.responseJSON.text}


  AppRouter
