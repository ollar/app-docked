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
          _.defer => (callback.apply(@, args)) if (callback)
          do =>
            App.vent.trigger 'loading:done'

      @

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
