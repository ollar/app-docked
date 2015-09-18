define [
  'app'
  'marionette'
  'controller'
  ], (App, Mn, routeController)->

  Router = Mn.AppRouter.extend

    execute: (callback, args, name)->
      do =>
        App.vent.trigger 'loading:start'
        do =>
          callback.apply(@, args)
          do =>
            App.vent.trigger 'loading:done'
      @

      (callback.apply(@, args)) if (callback)


    appRoutes:
      '': 'home'
      'register': 'register'
      'users': 'showUsers'
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

    controller: routeController

  Router
