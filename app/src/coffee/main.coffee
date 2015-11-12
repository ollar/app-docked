require ['config'], ->
  require [
    'prefix'
    'jquery.cookie'
    'marionette'
    'router'
    'app'
    'views/topMenu'
    'views/common/overlay'
    'wreqr'
    ], (Prefix, jcookie, Mn, Router, App, TopMenu, Overlay, wreqr)->

    # ====================================

    App.navigate = (route)->
      Backbone.history.navigate route, yes

    # ====================================
    # Preparing app
    # ====================================

    Mn.Behaviors.behaviorsLookup = ->
      App.Behaviors

    App.on "before:start", ->
      @navigation.show(new TopMenu())
      @overlay.show(new Overlay())


    App.on 'start', ->
      new Router()
      Backbone.history.start
        pushState: true
        root: '/'

    # ====================================
    # Specifying regions
    # ====================================

    App.addRegions
      navigation: "#navigation"
      main: "#main-content"
      messages: "#message-wrapper"
      overlay: "#overlay"

    App.getRegion('main').attachHtml = (view)->

      promise = new Promise (resolve, reject)=>
        App.vent.trigger 'loading:start'
        @$el.addClass('page-change')
        _.delay =>
          resolve()
        , 400

      promise
        .then =>
          _.defer =>
            Mn.Region::attachHtml.call(@, view)
        .then =>
          _.defer =>
            App.vent.trigger 'loading:done'
            @$el.removeClass('page-change')

    # ====================================
    # Starting the App
    # ====================================

    App.start()
